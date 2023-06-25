{

  _config+:: {

    applications+: {

      nginx+: {
        valueFiles+: [
          '$values/test/tanka/lib/variants/local/nginx/values-local.yaml',
        ],
      },

    },

  },
}
