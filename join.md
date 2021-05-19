# Anatomie d'un JOIN
Un JOIN colle 2 tables virtuelles pour générer une nouvelle table virtuelle :
- la table résultante aura A+B colonnes (où A est le nb de colonnes de la table virtuelle de gauche et B celle de droite)
- elle aura A*B lignes (où A est le nb de lignes de gauche et B le nb de lignes de droite)
- le critère de jointure (ON) éliminera ensuite toutes les combinaisons incohérentes
```sql
SELECT *
FROM phrase -- 2 lignes/enregistrements, 7 colonnes
JOIN noun ON noun.id = phrase.noun_id -- 5 lignes/enregistrements, 2 colonnes
-- la table virtuelle ainsi composée fait 10*9
-- mais le critère de jointure (ON) retire tous les couples incohérents => 2 lignes
JOIN adjective ON adjective.id = phrase.adjective_id -- 3 lignes, 2 colonnes
-- la table temporaire (phrase*noun) issue du premier JOIN est jointe à adjective
-- ça donne une table temporaire (phrase*noun*adjective) de 11 colonnes et 6 lignes
-- le critère de jointure va ensuite éliminer les lignes incohérentes => 2 lignes
```
En pratique, le critère de jointure n'est pas vraiment appliqué après que toutes les données aient été insérées dans la table virtuelle mais plutôt, en fonction des SGBD :
- progressivement, par un processus parallèle, ce qui permet de faire tourner simultanément 2 routines très simples : un algo qui ajoute bêtement toutes les combinaisons possibles, et un autre qui applique le critère de jointure
- séquentiellement, par un unique processus, qui considère tout de même chaque combinaison mais n'ajoute à la table virtuelle que celles qui satisfont le critère de jointure
Dans tous les cas, retenez qu'un JOIN a un coût, notamment sur de grandes collections de données, et que l'ordre des jointures, lorsqu'il y en a plusieurs, peut tout changer.