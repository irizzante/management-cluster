local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.9/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;
local utils = import 'utils.libsonnet';

{
  _config+:: {

    applications+: {

      minio:
        utils.helmTemplate +
        application.metadata.withAnnotations({
          'argocd.argoproj.io/sync-wave': '-5',
        }) +
        application.spec.destination.withNamespace('minio') +
        utils.helmTemplate.withSourcesMixin('https://charts.bitnami.com/bitnami', 'minio', self.minio.targetRevision, self.minio.valueFiles) +
        utils.helmTemplate.withTargetRevision((importstr 'version.txt')) +
        utils.helmTemplate.withValueFilesMixin('$values/apps/lib/variants/minio/values.yaml'),

    },

  },
}
