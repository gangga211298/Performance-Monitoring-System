DROP TABLE IF EXISTS tb_utilisasi_25;

CREATE TABLE tb_utilisasi_25 AS

WITH tb_promo_clean AS (
  SELECT DISTINCT ON (VIN) * FROM tb_promo),
tb_ring_clean AS (
  SELECT DISTINCT ON (kode_pos) * FROM tb_ring),
tb_target_clean AS (
  SELECT DISTINCT ON (tanggal) * FROM tb_target_summary),

Dashboard_UTI as (
select a.*,
	c.week AS Week,
	c.bulan AS "Month",
	c.hari AS "Day",
	b.tgl_spp AS Tgl_CAI,
	b.kelompok_pekerjaan AS Group_job,
	b.nomor_spp AS no_spp_cai,
	ROW_NUMBER() OVER (PARTITION BY b.nomor_spp ORDER BY a.kelompok DESC) AS rn_cai
from tb_utilisasi a
LEFT JOIN tb_target_clean c
ON a.tgl_next_service= c.tanggal
LEFT JOIN tb_spp_25 b
ON a.no_rangka= b.nomor_rangka
AND b.tgl_spp BETWEEN 
      a.tgl_next_service - INTERVAL '15 day' 
      AND 
      a.tgl_next_service + INTERVAL '30 day'
)
SELECT
q.*,
w.type1 AS Job_Type1,
w.type2 AS Job_Type2,
w.type3 AS Job_Type3
FROM Dashboard_UTI q
LEFT JOIN tb_job w
	ON q.Group_Job = w.kelompok_job
ORDER BY tgl_next_service DESC;