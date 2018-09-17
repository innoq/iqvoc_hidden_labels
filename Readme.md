## iQvoc hidden labels


### DB setup

- MySQL
- `rake db:migrate`
- `rake iqvoc:db:seed_all`

### Dockerhub Push

```
docker build . -t innoq/iqvoc_hidden_labels -f $(bundle show iqvoc)/Dockerfile
docker push innoq/iqvoc_hidden_labels
```

### Production Setup

Generate Secret Key Base:
`rake secret`

Create Docker volume:
`docker volume create iqvoc_export`
`docker volume create iqvoc_import`

Docker container start command:
`docker run -d --restart=always --net="host" -e "DB_HOST=x"-e "DB_USER=y" -e "DB_PW=z" -e SECRET_KEY_BASE=a -v iqvoc_export:/iqvoc/public/export -v iqvoc_import:/iqvoc/public/import innoq/iqvoc_hidden_labels`

