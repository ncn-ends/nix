# open grafana and add a Prometheus data source, with the url as "http://127.0.0.1:9001"

{config, ...}: {
  # services.grafana = {
  #   enable = true;
  #     port = 2342;
  #     addr = "127.0.0.1";
  #   # settings.server = {
  #   # };
  # };

  # services.prometheus = {
  #   enable = true;
  #   port = 9001;
  #   exporters = {
  #     node = {
  #       enable = true;
  #       enabledCollectors = [ "systemd" ];
  #       port = 9002;
  #     };
  #   };

  #   scrapeConfigs = [
  #     {
  #       job_name = "nodes";
  #       static_configs = [
  #         {
  #           targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
  #         }
  #       ];
  #     }
  #   ];
  # };
}