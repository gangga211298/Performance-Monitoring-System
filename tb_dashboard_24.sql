DROP TABLE IF EXISTS tb_Dashboard_24;

CREATE TABLE tb_Dashboard_24 AS

WITH tb_promo_clean AS (
  SELECT DISTINCT ON (VIN) * FROM tb_promo),

tb_ring_clean AS (
  SELECT DISTINCT ON (kode_pos) * FROM tb_ring),

tb_target_clean AS (
  SELECT DISTINCT ON (tgl_SPP) * FROM tb_target),

DashboardData AS (
    SELECT DISTINCT
		a.*,
		CAST(Tgl_SPP + INTERVAL '1 year' AS DATE) AS Tgl_SPP_Plus_1_Year,
		b.type1 AS Job_Type1,
        b.type2 AS Job_Type2,
        b.type3 AS Job_Type3,
		COALESCE(d.YOS, 'OOA') AS FOA_PMA,
		COALESCE(e.YOS, 'Ring 5') AS Ring,
        COALESCE(f.Kelompok_Promo, 'NO PROGRAM') AS "Program",
        COALESCE(i.string_field_2, 'Other Dealer') AS Outlet,
		ROW_NUMBER() OVER (PARTITION BY a.Nomor_SPP ORDER BY a.Tgl_SPP DESC) AS rn
	FROM tb_spp_24 a
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
	)
SELECT
q.*,
c.week AS Week,
c.month AS "Month",
c.day AS "Day"
FROM DashboardData q
LEFT JOIN tb_target_clean c
        ON q.Tgl_SPP_Plus_1_Year = c.tgl_spp
WHERE rn = 1
ORDER BY Tgl_SPP DESC;
