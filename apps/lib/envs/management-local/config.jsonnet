local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.9/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;

(import 'base/config.jsonnet') +
(import 'variants/prod/config.jsonnet') +
(import 'variants/local/config.jsonnet') +
(import 'variants/crossplane/config.jsonnet') +
(import 'variants/externalsecrets-bitwarden/config.jsonnet') +
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

      argocd+: {
        targetRevision: (importstr 'envs/management-local/argocd/version.txt'),
        valueFiles+: [
          '$values/apps/lib/envs/management-local/argocd/values.yaml',
          '$values/apps/lib/envs/management-local/argocd/values-replicas.yaml',
        ],
      },

      'metrics-server'+: {
        targetRevision: (importstr 'envs/management-local/metrics-server/version.txt'),
        valueFiles+: [
          '$values/apps/lib/envs/management-local/metrics-server/values-replicas.yaml',
        ],
      },

      crossplane+: {
        targetRevision: (importstr 'envs/management-local/crossplane/version.txt'),
      },

    },

  },
}
