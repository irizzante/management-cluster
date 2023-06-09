local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.5/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;

(import 'base/config.jsonnet') +
(import 'variants/prod/config.jsonnet') +
{

  _config+:: {

    applications+: {

      nginx+: {
        targetRevision: (importstr 'envs/management-local/nginx/version.txt'),
        valueFiles+: [
          '$values/test/tanka/lib/envs/management-local/nginx/values-management-local.yaml',
          '$values/test/tanka/lib/envs/management-local/nginx/values-settings.yaml',
          '$values/test/tanka/lib/envs/management-local/nginx/values-replicas.yaml',
        ],
      },
      prometheus+: {
        targetRevision: (importstr 'envs/management-local/prometheus/version.txt'),
        valueFiles+: [
          '$values/test/tanka/lib/envs/management-local/prometheus/values-settings.yaml',
          '$values/test/tanka/lib/envs/management-local/prometheus/values-replicas.yaml',
        ],
      },

    },

  },
}
