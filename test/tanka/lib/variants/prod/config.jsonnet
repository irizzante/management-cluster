{

  _config+:: {

    applications+: {

      nginx+: {
        valueFiles+: [
          '$values/test/tanka/lib/variants/prod/nginx/values-prod.yaml',
        ],
      },

      prometheus+: {
        valueFiles+: [
          '$values/test/tanka/lib/variants/prod/prometheus/values-prod.yaml',
        ],
      },

    },

  },
}
