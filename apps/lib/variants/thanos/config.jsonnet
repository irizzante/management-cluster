local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.9/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;
local utils = import 'utils.libsonnet';

{
  _config+:: {

    applications+: {

      thanos:
        utils.helmTemplate +
        application.spec.destination.withNamespace('thanos') +
        utils.helmTemplate.withSourcesMixin('https://charts.bitnami.com/bitnami', 'thanos', self.thanos.targetRevision, self.thanos.valueFiles) +
        utils.helmTemplate.withTargetRevision((importstr 'version.txt')) +
        utils.helmTemplate.withValueFilesMixin('$values/apps/lib/variants/thanos/values.yaml'),

    },

  },
}
