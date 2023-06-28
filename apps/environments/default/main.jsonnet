local environments = import 'envs.jsonnet';
local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';

{
  environment(environment)::
    tanka.environment.new(
      name=environment.name,
      namespace='argocd',
      apiserver='https://0.0.0.0:6443'
    )
    + tanka.environment.withLabels({ environment: environment.name })
    + tanka.environment.withData(
      (import 'argocd.libsonnet') +
      environment.config
    )
    + {
      spec+: {
        injectLabels: true,
      },
    },

  envs: {
    [env.name]: $.environment(env)
    for env in environments
  },
}
