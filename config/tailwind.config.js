const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          100: '#feebf1',
          200: '#fabbd0',
          300: '#f490b1',
          400: '#e76a94',
          500: '#d44a78',
          600: '#b23861',
        },
        gray: {
          100: '#f2f2f2',
          200: '#d3d3d3',
          300: '#7a7a7a',
          400: '#303036',
          500: '#17171c',
        },
        secondary: {
          100: '#a8a8a8',
          200: '#8f8f8f',
          300: '#757575',
          400: '#5c5c5c',
          500: '#424242',
          600: '#292929',
        },
        error: {
          100: '#ea6c83',
          200: '#e54865',
          300: '#e02447',
          400: '#c51c3b',
          500: '#a11730',
        },
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        logo: ['Roboto', ...defaultTheme.fontFamily.sans],
        display: ['Montserrat', 'Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
