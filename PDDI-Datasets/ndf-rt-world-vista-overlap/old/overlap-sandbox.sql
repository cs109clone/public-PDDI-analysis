# 269527 in NDF-RT
SELECT count(drug_interaction_id) FROM ndf_rt_interaction;
SELECT * FROM ndf_rt_interaction;
SELECT * FROM ndf_rt_interaction WHERE drug_1_rxcui = 3008 AND drug_2_rxcui = 10594;
SELECT * FROM ndf_rt_interaction WHERE drug_1_rxcui = 1005921 AND drug_2_rxcui = 4103;

# 2846 interactions in World Vista
SELECT count(drug_interaction_id) FROM drug_interaction;
SELECT * FROM drug_interaction;
SELECT * FROM drug_interaction WHERE drug_1_rxcui = 3008 AND drug_2_rxcui = 10594;
SELECT * FROM drug_interaction WHERE drug_1_rxcui = 1005921 AND drug_2_rxcui = 4103;
# RxCui's 3008 and 10594 are one example that should overlap

SELECT w.drug_1_rxcui AS world_vista_drug_1, w.drug_2_rxcui AS world_vista_drug_2, n.drug_1_rxcui AS ndf_rt_drug_1, n.drug_2_rxcui AS ndf_rt_drug_2
FROM drug_interaction w
INNER JOIN ndf_rt_interaction n
ON (w.drug_1_rxcui = n.drug_1_rxcui AND w.drug_2_rxcui = n.drug_2_rxcui);
/*WHERE w.drug_1_rxcui = 3008
AND n.drug_1_rxcui = 3008
AND w.drug_2_rxcui = 10594
AND n.drug_2_rxcui = 10594;*/

###############################################################################################################

# 265435 rows cumulative from both data sets (when no blanks, no nulls, duplicates permitted via UNION ALL).
# 261303 rows when no duplicates via UNION
# difference = 5715
# TODO: 1007804, 1111, more have some drug_2_rxcui new line characters
SELECT w.drug_1_rxcui, w.drug_2_rxcui 
FROM drug_interaction w
WHERE w.drug_1_rxcui != '' AND w.drug_2_rxcui != ''
UNION ALL
SELECT n.drug_1_rxcui, n.drug_2_rxcui
FROM ndf_rt_interaction n
WHERE n.drug_1_rxcui is not null AND n.drug_2_rxcui is not null;

# 4577 rows returned for interactions that are in both data sets in any capacity.
SELECT u.drug_1_rxcui, u.drug_2_rxcui, COUNT(*)
FROM(
	SELECT w.drug_1_rxcui, w.drug_2_rxcui 
	FROM drug_interaction w
	WHERE w.drug_1_rxcui != '' AND w.drug_2_rxcui != ''
	UNION ALL
	SELECT n.drug_1_rxcui, n.drug_2_rxcui
	FROM ndf_rt_interaction n
	WHERE n.drug_1_rxcui is not null AND n.drug_2_rxcui is not null) u
GROUP BY u.drug_1_rxcui, u.drug_2_rxcui
HAVING COUNT(*) > 1;