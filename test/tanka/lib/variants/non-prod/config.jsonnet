{

  _config+:: {

    applications+: {

      nginx+: {
        valueFiles+: [
          '$values/test/tanka/lib/variants/non-prod/nginx/values-replicas.yaml',
        ],
      },

      prometheus+: {
        valueFiles+: [
          '$values/test/tanka/lib/variants/non-prod/prometheus/values-replicas.yaml',
        ],
      },

    },

  },
}
