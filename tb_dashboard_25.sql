DROP TABLE IF EXISTS tb_Dashboard_25;

CREATE TABLE tb_Dashboard_25 AS

WITH tb_promo_clean AS (
  SELECT DISTINCT ON (VIN) * FROM tb_promo),

tb_ring_clean AS (
  SELECT DISTINCT ON (kode_pos) * FROM tb_ring),

tb_target_clean AS (
  SELECT DISTINCT ON (tanggal) * FROM tb_target_summary),

DashboardData AS (
    SELECT DISTINCT
		a.*,
		b.type1 AS Job_Type1,
        b.type2 AS Job_Type2,
        b.type3 AS Job_Type3,
		c.week AS Week,
		c.bulan AS "Month",
		c.hari AS "Day",
		case when g.otd_b = 'X' or g.early = 'X' or g.late = 'X' then 'Booking'
		else 'Non Booking'
		end as Keterangan_Booking,
		COALESCE(d.YOS, 'OOA') AS FOA_PMA,
		COALESCE(e.YOS, '>30km') AS Ring,
        COALESCE(f.Kelompok_Promo, 'NO PROGRAM') AS "Program",
		
		case when k.kelompok = 'Suggestion'
		and b.type1 = 'GR'
		and (k.tgl_next_service - a.tgl_spp) > 0
        and (k.tgl_next_service - a.tgl_spp) < 30
		then 'Saran Service'
		else 'Non Saran Service'
		end as Keterangan_SS,
		
		case when h.Kontribusi_MRA = 'X' then 'MRA Contribution'
		else 'Customer Inisiation'
		end as Kontribusi_MRA,

		case when h.Kontribusi_effort = 'Call' then 'Effort'
		else 'Walk-In'
		end as Kontribusi_Effort,
		
        COALESCE(i.string_field_2, 'Other Dealer') AS Outlet,
		
		CASE
		WHEN a.nama_pelanggan___stnk_ ILIKE '%PT %'
       		OR a.nama_pelanggan___stnk_ ILIKE '%CV %'
			OR a.nama_pelanggan___stnk_ ILIKE '%PT. %'
		 	OR a.nama_pelanggan___stnk_ ILIKE '%CV. %'
         	OR a.nama_pelanggan___stnk_ ILIKE '%YAYASAN%'
         	OR a.nama_pelanggan___stnk_ ILIKE '%KOPERASI%'
         	OR a.nama_pelanggan___stnk_ ILIKE '%PERUM%'
         	OR a.nama_pelanggan___stnk_ ILIKE '%BADAN%'
		 	OR a.nama_pelanggan___stnk_ ILIKE '%KEMENTRIAN%'
         	OR LEFT(UPPER(a.nama_pelanggan___stnk_), 2) IN ('PT', 'CV')
    	THEN 'Fleet'
    	ELSE 'Retail'
		END AS Kategori_Customer,
		
		ROW_NUMBER() OVER (PARTITION BY a.Nomor_SPP ORDER BY a.Tgl_SPP DESC) AS rn
	FROM tb_spp_25 a
	LEFT JOIN tb_job b
		ON a.Kelompok_Pekerjaan = b.kelompok_job
	LEFT JOIN tb_foa d
		ON a.kode_pos = d."Kode Pos"
	LEFT JOIN tb_ring_clean e
		ON a.kode_pos = e.kode_pos
	LEFT JOIN tb_promo_clean f
		ON a.Nomor_Rangka = f.VIN
	LEFT JOIN tb_outlet i
		ON a.Dealer_Penjual = i.string_field_1
	LEFT JOIN tb_target_clean c
        ON a.tgl_spp= c.tanggal
	LEFT JOIN tb_epk_25 g
        ON a.nomor_spp = g.nomor_spp
	LEFT JOIN tb_as_25 h
        ON a.nomor_spp = h.no_spp
	LEFT JOIN tb_ss_25 k
        ON a.nomor_rangka = k.no_rangka
	)
SELECT
q.*
FROM DashboardData q
where rn = 1
ORDER BY Tgl_SPP DESC;

