local argoCd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.9/main.libsonnet';
local application = argoCd.argoproj.v1alpha1.application;
local utils = import 'utils.libsonnet';

{
  _config+:: {

    applications+: {

      'cert-manager':
        utils.helmTemplate +
        application.spec.destination.withNamespace('cert-manager') +
        utils.helmTemplate.withSourcesMixin('https://charts.jetstack.io', 'cert-manager', self['cert-manager'].targetRevision, self['cert-manager'].valueFiles) +
        utils.helmTemplate.withTargetRevision((importstr 'version.txt')) +
        utils.helmTemplate.withValueFilesMixin('$values/apps/lib/base/cert-manager/values.yaml'),

    },

  },
}
