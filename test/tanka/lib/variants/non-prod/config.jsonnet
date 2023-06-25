{

  _config+:: {

    applications+: {

      nginx+: {
        valueFiles+: [
          '$values/test/tanka/lib/variants/non-prod/nginx/values-non-prod.yaml',
        ],
      },

      prometheus+: {
        valueFiles+: [
          '$values/test/tanka/lib/variants/non-prod/prometheus/values-non-prod.yaml',
        ],
      },

    },

  },
}
