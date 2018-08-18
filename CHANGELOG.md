## 2.0.0

* Fixed `render @pagination` for namespaced resources.
* [BREAKING] Moved view to "app/views/application/_pagination.html.erb".
* [BREAKING] Renamed locales file to "foliate.en.yml".


## 1.2.0

* Added `--bootstrap` option to `foliate:install` generator to apply
  Bootstrap 4 classes in generated stylesheet.


## 1.1.0

* Added `Pagination#each_query_param` to seamlessly handle nested data
  structures in `query_params` when generating form fields.


## 1.0.0

* Initial release
