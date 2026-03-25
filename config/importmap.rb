# Pin npm packages by running ./bin/importmap

pin "application"
pin_all_from "app/javascript"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
pin "@rails/ujs", to: "@rails--ujs.js" # @7.1.3
