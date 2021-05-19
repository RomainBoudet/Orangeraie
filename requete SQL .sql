-- Les sous-requêtes qui piquent
-- pas de panique si vous n'êtes pas capables de les reproduire par vous-mêmes
-- l'objectif est ici de comprendre progressivement le principe et le cheminement
-- la 1ere sous-requêtes : les familles non-juteuses
SELECT *
FROM family
-- on liste uniquement les familles absentes de la liste ci-dessous
WHERE id NOT IN (
	-- mes familles juteuses
	SELECT DISTINCT family_id
	FROM species
	-- au niveau des espèces, on peut récupérer l'id de la famille
	WHERE id IN (
		-- mes espèces juteuses
		SELECT species_id
		FROM variety
		-- agrégat par espèce (ici, on n'a que l'id de l'espèce)
		GROUP BY species_id
		-- moyenne de la jutosité par espèce
		HAVING avg(juiciness) > 2.5
	)
);
-- la 2e : les plantations qui contiennent des mandarines
SELECT *
FROM field
WHERE id IN (
	SELECT field_id
	FROM row
	WHERE variety_id IN (
		SELECT id
		FROM variety
		WHERE species_id IN (
			SELECT id
			FROM species
			WHERE family_id = (
				SELECT id
				FROM family
				WHERE name = 'mandarine'
			)
		)
	)
);
-- bonus du turfu : le WITH
-- équivalent aux requêtes imbriquées
-- avantages : 
-- 1. moins d'imbrications
-- 2. sens de lecture identique pour l'humain et le parser
-- inconvénient :
-- légèrement plus gourmand en ressources
-- (car le parser prend la peine de nommer chaque table virtuelle)
-- NB : l'impact réel de WITH ne se mesure que sur des très gros volumes de données
-- par exemple quelques tables de plusieurs millions de lignes
WITH mandarine_family AS (
	SELECT id
	FROM family
	WHERE name = 'mandarine'
),
mandarine_species AS (
	SELECT species.id
	FROM species
	JOIN mandarine_family ON species.family_id = mandarine_family.id
),
mandarine_varieties AS (
	SELECT variety.id
	FROM variety
	JOIN mandarine_species ON variety.species_id = mandarine_species.id
),
mandarine_rows AS (
	SELECT DISTINCT field_id
	FROM row
	JOIN mandarine_varieties ON row.variety_id = mandarine_varieties.id
)
SELECT field.*
FROM field
JOIN mandarine_rows ON field.id = mandarine_rows.field_id;
















