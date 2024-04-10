local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.9/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;
local utils = import 'utils.libsonnet';

{
  _config+:: {

    applications+: {

      crossplane:
        utils.helmTemplate +
        application.metadata.withAnnotations({
          'argocd.argoproj.io/sync-wave': '-5',
        }) +
        application.spec.destination.withNamespace('crossplane-system') +
        application.spec.withSourcesMixin(
          application.spec.sources.withRepoURL('https://charts.crossplane.io/stable') +
          application.spec.sources.withTargetRevision(self.crossplane.targetRevision) +
          application.spec.sources.withChart('crossplane') +
          application.spec.sources.helm.withValueFiles(self.crossplane.valueFiles)
        ) +
        utils.helmTemplate.withValueFilesMixin('$values/apps/lib/variants/crossplane/values.yaml'),

    },

  },
}
