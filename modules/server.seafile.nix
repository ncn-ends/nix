{ stable, config, ...}:
{
  services.seafile = {
    enable = true;
    adminEmail = "ncn.ends@gmail.com";
    initialAdminPassword = "password";
    ccnetSettings = {
      General = {
        SERVICE_URL = "http://127.0.0.1:8000";
      };
    };
  };
}