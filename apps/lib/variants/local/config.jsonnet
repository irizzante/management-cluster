{

  _config+:: {

    applications+: {

      nginx+: {
        valueFiles+: [
          '$values/apps/lib/variants/local/nginx/values-local.yaml',
        ],
      },

      'metrics-server'+: {
        valueFiles+: [
          '$values/apps/lib/variants/local/metrics-server/values-local.yaml',
        ],
      },

    },

  },
}
