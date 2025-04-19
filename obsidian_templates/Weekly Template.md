---
tags: [weekly, TODO]
---
# Week `=dateformat(date(today), "W")`
## Today is `=link(dateformat(date(today), "cccc, MMMM dd yyyy"))`
###### [[<% tp.date.now("gggg [Index]") %>]]

#### Tasks
  ```dataview
  task from #daily
  where !contains(file.path, "99 - templates/")
  and !completed
  ```

---
#### Other Tasks & Dates
- [ ] TODO

#### Other TODOs
```dataview
table without id file.link as Other-TODOs from #TODO
where !contains(file.path, "99 - templates/")
```
