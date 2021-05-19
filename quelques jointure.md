# Quelques jointures =>

## affichons le nom scientifique, le nom commun et la famille de toutes les espèces :

```sql
SELECT * FROM species JOIN family on family.id = species.family_id
```

## Pour un résultat plus propre... sans les tables id :

```sql
SELECT species.scientific_name, species.common_name,
family.name AS family_name FROM species JOIN family on family.id = species.family_id;
```

## Affichons maintenant les espèces pour lesquelles il existe au moins une variété ayant une amertume de 5 :

```sql
SELECT species.common_name AS nom_espece, variety.bitterness, variety.cultivar FROM species JOIN variety ON species.id = variety.species_id WHERE variety.bitterness = 5;
```


## Ces même espéces sans doublon :

```sql
SELECT DISTINCT species.common_name AS nom_espece, variety.bitterness FROM species JOIN variety 
ON species.id = variety.species_id WHERE variety.bitterness = 5;
```

## Affichons le nom de la plantation et le libellé des rangées concernées (une ligne par rangée)

```sql
SELECT DISTINCT species.common_name AS nom_espece, variety.bitterness, field.name as field, row.label as row FROM species JOIN variety 
ON species.id = variety.species_id JOIN row ON row.variety_id = variety.id JOIN field ON row.field_id = field.id WHERE variety.bitterness = 5;
```

