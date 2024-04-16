local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.9/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;
local utils = import 'utils.libsonnet';

(import 'base/config.jsonnet') +
(import 'base/crossplane/config.jsonnet') +
(import 'base/externalsecrets-bitwarden/config.jsonnet') +
(import 'base/minio/config.jsonnet') +
(import 'base/thanos/config.jsonnet') +
(import 'variants/local/config.jsonnet') +
{

  _config+:: {

    applications+: {

      nginx+:
        utils.helmTemplate.withValueFilesMixin('$values/apps/lib/envs/management-local/nginx/values-replicas.yaml') +
        {
          targetRevision: (importstr 'envs/management-local/nginx/version.txt'),
        },

      prometheus+:
        utils.helmTemplate.withValueFilesMixin([
          '$values/apps/lib/envs/management-local/prometheus/values-replicas.yaml',
          '$values/apps/lib/envs/management-local/prometheus/values.yaml',
        ]) +
        {
          targetRevision: (importstr 'envs/management-local/prometheus/version.txt'),
        },

      'external-secrets'+: {
        targetRevision: (importstr 'envs/management-local/external-secrets/version.txt'),
      },

      'external-secrets-manifests':
        utils.appTemplate +
        application.spec.source.withRepoURL('https://github.com/irizzante/management-cluster.git') +
        application.spec.source.withTargetRevision('HEAD') +
        application.spec.source.withPath('apps/lib/envs/management-local/external-secrets/manifests'),

      argocd+:
        {
          targetRevision: (importstr 'envs/management-local/argocd/version.txt'),
        },

      'metrics-server'+:
        utils.helmTemplate.withValueFilesMixin('$values/apps/lib/envs/management-local/metrics-server/values-replicas.yaml') +
        {
          targetRevision: (importstr 'envs/management-local/metrics-server/version.txt'),
        },

      crossplane+:
        {
          targetRevision: (importstr 'envs/management-local/crossplane/version.txt'),
        },

      minio+:
        utils.helmTemplate.withValueFilesMixin('$values/apps/lib/envs/management-local/minio/values.yaml'),

      thanos+:
        utils.helmTemplate.withValueFilesMixin('$values/apps/lib/envs/management-local/thanos/values-replicas.yaml'),

      vcluster:
        utils.helmTemplate +
        utils.helmTemplate.withTargetRevision(importstr 'envs/management-local/vcluster/version.txt') +
        application.spec.destination.withNamespace('test-vcluster') +
        utils.helmTemplate.withSourcesMixin('https://charts.loft.sh', 'vcluster', self.vcluster.targetRevision, self.vcluster.valueFiles) +
        utils.helmTemplate.withValueFilesMixin('$values/apps/lib/envs/management-local/vcluster/values.yaml'),


    },

  },
}
