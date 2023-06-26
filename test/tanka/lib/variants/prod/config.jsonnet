{

  _config+:: {

    applications+: {

      nginx+: {
        valueFiles+: [
          '$values/test/tanka/lib/variants/prod/nginx/values-prod.yaml',
          '$values/test/tanka/lib/variants/prod/nginx/values-replicas.yaml',
        ],
      },

      prometheus+: {
        valueFiles+: [
          '$values/test/tanka/lib/variants/prod/prometheus/values-replicas.yaml',
        ],
      },

    },

  },
}
