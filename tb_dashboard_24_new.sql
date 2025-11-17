DROP TABLE IF EXISTS tb_Dashboard_24_new;

CREATE TABLE tb_Dashboard_24_new AS

WITH tb_promo_clean AS (
  SELECT DISTINCT ON (VIN) * FROM tb_promo),
tb_ring_clean AS (
  SELECT DISTINCT ON (kode_pos) * FROM tb_ring),
tb_target_clean AS (
  SELECT DISTINCT ON (tgl_SPP) * FROM tb_target),
  
DashboardData as (
	select a.*,
	cast(a.tgl_spp + interval '1 YEAR' as Date) as Tgl_SPP_Plus_1_Year,
	b.type1 as Job_Type1,
	b.type2 as Job_Type2,
	b.type3 as Job_Type3,
	coalesce (c.yos,'OOA') as FOA_PMA,
	coalesce (d.yos,'Ring 5') as Ring,
	coalesce (e.kelompok_promo,'NO PROGRAM') as "Program",
	coalesce (f.string_field_2, 'Other Dealer') as Outlet,
	ROW_NUMBER() OVER (PARTITION BY a.Nomor_SPP ORDER BY a.Tgl_SPP DESC) AS rn
	
from tb_spp_24 a
	left join tb_job b
	on a.Kelompok_pekerjaan = b.kelompok_job
	left join tb_foa c
	on a.Kode_pos = c."Kode Pos"
	left join tb_ring_clean d
	on a.Kode_pos = d.Kode_Pos
	left join tb_promo_clean e
	on a.nomor_rangka = e.vin
	left join tb_outlet f
	on a.dealer_penjual = f.string_field_1
	)
select 
g.*,
h.Week,
h.Month,
h.Day
from DashboardData g
left join tb_target_clean h
on g.Tgl_SPP_Plus_1_Year = h.tgl_spp
order by tgl_spp DESC
;