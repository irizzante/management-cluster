local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.9/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;
local utils = import 'utils.libsonnet';

{
  _config+:: {

    applications+: {

      'cluster-secret-store':
        utils.appTemplate +
        application.metadata.withAnnotationsMixin({
          'argocd.argoproj.io/sync-wave': '-10',
        }) +
        utils.appTemplate.withEnabled(true) +
        application.spec.destination.withNamespace('external-secrets') +
        application.spec.source.withRepoURL('https://github.com/irizzante/management-cluster.git') +
        application.spec.source.withTargetRevision(self['cluster-secret-store'].targetRevision) +
        application.spec.source.withPath('apps/lib/variants/externalsecrets-bitwarden/cluster-secret-store'),

    },

  },
}
