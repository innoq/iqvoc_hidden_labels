## iQvoc for OeRK


### DB setup

- MySQL
- `rake db:migrate`
- `rake iqvoc:db:seed_all`

### Dockerize

```
docker build . -f $(bundle show iqvoc)/Dockerfile
```

