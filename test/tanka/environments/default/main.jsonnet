local environments = import 'envs.jsonnet';
local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';

{
  environment(environment)::
    tanka.environment.new(
      name=environment,
      namespace='argocd',
      apiserver='https://0.0.0.0:6443'
    )
    + tanka.environment.withLabels({ environment: environment })
    + tanka.environment.withData(
      (import 'argocd.libsonnet') +
      (import 'envs/management-local/config.jsonnet')
    )
    + {
      spec+: {
        injectLabels: true,
      },
    },

  envs: {
    [env]: $.environment(env)
    for env in environments
  },
}
