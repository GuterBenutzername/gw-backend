{
  services.postgres = {
    service.image = "postgres:14";
    service.volumes = ["${toString ./.}/postgres-data:/var/lib/postgresql/data"];
    service.environment.POSTGRES_PASSWORD = "notused";
  };
}
