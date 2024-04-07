local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.5/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;

{
  _config+:: {

    applications+: {

      crossplane: self.helmAppTemplate {
        annotations+: {
          'argocd.argoproj.io/sync-wave': '-5',
        },
        valueFiles+: [
          '$values/apps/lib/variants/crossplane/values.yaml',
        ],
        sources+: [
          (
            application.spec.source.withRepoURL('https://charts.crossplane.io/stable') +
            application.spec.source.withTargetRevision(self.targetRevision) +
            application.spec.source.withChart('crossplane') +
            application.spec.source.helm.withValueFiles(self.valueFiles)
          ).spec.source,
        ],

      },

    },

  },
}
