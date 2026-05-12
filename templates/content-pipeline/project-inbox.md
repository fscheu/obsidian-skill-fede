---
created: {{date}}
modified: {{date}}
leido: false
tags:
  - meta
  - content-pipeline
---

# Content Pipeline Inbox — {{project_name}}

Notas capturadas automáticamente por el content-pipeline relacionadas con este proyecto.

```dataview
TABLE
  relevance_score AS "Score",
  relevance_reasoning AS "Por qué",
  author AS "Fuente",
  processed AS "Fecha"
FROM "00_Inbox/Content-Pipeline"
WHERE contains(projects, "{{project_name}}")
SORT relevance_score DESC
```

---

> Esta nota es generada automáticamente. No editar manualmente.
> Para agregar manualmente una nota al proyecto, agregá `{{project_name}}` al campo `projects` de su frontmatter.
