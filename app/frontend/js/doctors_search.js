import Rails from '@rails/ujs';
document.addEventListener('change', (event) => {
  let input = event.target;
  if (input.matches('#doctor_category_id')) {
    Rails.ajax({
      url: `/doctors_search/${input.value}`,
      type: 'get',
      dataType : 'script',
      format: 'js'
    });
  }
});
