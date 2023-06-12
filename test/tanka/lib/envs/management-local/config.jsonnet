local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.5/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;

(import 'base/config.jsonnet') +
(import 'variants/prod/config.jsonnet') +
(import 'variants/local/config.jsonnet') +
{

  _config+:: {

    applications+: {

      nginx+: {
        targetRevision: (importstr 'envs/management-local/nginx/version.txt'),
        valueFiles+: [
          '$values/test/tanka/lib/envs/management-local/nginx/values-settings.yaml',
        ],
      },

      prometheus+: {
        targetRevision: (importstr 'envs/management-local/prometheus/version.txt'),
        valueFiles+: [
          '$values/test/tanka/lib/envs/management-local/prometheus/values-settings.yaml',
        ],
      },

      externalSecrets+: {
        targetRevision: (importstr 'envs/management-local/external-secrets/version.txt'),
        valueFiles+: [
          '$values/test/tanka/lib/envs/management-local/external-secrets/values-settings.yaml',
        ],
      },

      clusterStore+: {
        spec+: application.spec.source.withPath('envs/management-local/cluster-store/'),
      },

    },

  },
}
