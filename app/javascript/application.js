// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

['turbo:load', 'turbo:render'].forEach(turbo_event => {
	document.addEventListener(turbo_event, function() {
		// User registration page
		// Hide the family ID field if creating a new family
		// Hide the family name field if joining an existing family
		let familyCodeField = document.getElementById('family-code-field');
		let familyNameField = document.getElementById('family-name-field');

		if (familyCodeField && familyNameField) {
			let newFamilyTriggers = document.querySelector('[data-action="new-family"]')
			newFamilyTriggers.addEventListener('click', function() {
			  familyCodeField.style.display = 'none';
			  familyNameField.style.display = 'block';
			});

			let existingFamilyTriggers = document.querySelector('[data-action="existing-family"]')
			existingFamilyTriggers.addEventListener('click', function() {
			  familyCodeField.style.display = 'block';
			  familyNameField.style.display = 'none';
			});
		}
	});
});
