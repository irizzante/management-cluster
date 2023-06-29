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
          '$values/apps/lib/envs/management-local/nginx/values-replicas.yaml',
        ],
      },

      prometheus+: {
        targetRevision: (importstr 'envs/management-local/prometheus/version.txt'),
        valueFiles+: [
          '$values/apps/lib/envs/management-local/prometheus/values-replicas.yaml',
        ],
      },

      'external-secrets'+: {
        targetRevision: (importstr 'envs/management-local/external-secrets/version.txt'),
      },

      'cluster-store'+: {
        source+: application.spec.source.withPath('apps/lib/envs/management-local/cluster-store/'),
      },

      argocd+: {
        targetRevision: (importstr 'envs/management-local/argocd/version.txt'),
        valueFiles+: [
          '$values/apps/lib/envs/management-local/argocd/values-replicas.yaml',
        ],
      },

    },

  },
}
