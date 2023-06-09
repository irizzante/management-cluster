{

  _config+:: {

    applications+: {

      nginx+: {
        valueFiles+: [
          '$values/test/tanka/lib/variants/' + self.variant + '/nginx/values-' + self.variant + '.yaml',
          '$values/test/tanka/lib/variants/' + self.variant + '/nginx/values-replicas.yaml',
        ],
      },

      prometheus+: {
        valueFiles+: [
          '$values/test/tanka/lib/variants/' + self.variant + '/prometheus/values-' + self.variant + '.yaml',
          '$values/test/tanka/lib/variants/' + self.variant + '/prometheus/values-replicas.yaml',
        ],
      },

    },

  } + {

    applications+: {
      [app.key]+: {
        variant: 'non-prod',
      }
      for app in std.objectKeysValues(super.applications)
    },

  },
}
