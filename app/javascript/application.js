// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
// Sortable wishlist tables
// I've encountered errors with this library, so I'm intentionally using the unminified version
import './sourtable.js'

// All these turbo events are ways a page can load
['turbo:load', 'turbo:render', 'turbo:morph'].forEach(turbo_event => {
	document.addEventListener(turbo_event, function() {
		// User registration: Show and hide family fields
		// Hide the family ID field if creating a new family
		// Hide the family name field if joining an existing family
		let familyCodeField = document.getElementById('family-code-field');
		let familyNameField = document.getElementById('family-name-field');

		if (familyCodeField && familyNameField) {
			let newFamilyTriggers = document.querySelector('[data-action="new-family"]')
			newFamilyTriggers.addEventListener('click', function() {
			  familyCodeField.classList.add('d-none');
			  familyNameField.classList.remove('d-none');
			});

			let existingFamilyTriggers = document.querySelector('[data-action="existing-family"]')
			existingFamilyTriggers.addEventListener('click', function() {
			  familyCodeField.classList.remove('d-none');
			  familyNameField.classList.add('d-none');
			});
		}

		// Home page: Sortable wishlist tables
		for (const table of document.querySelectorAll('.item-output-table')) {
			if (!table.classList.contains('sourtable-initiated')) {
				// [2, 3] indicates Description and Link should not be sortable
				// col_4 identifies Bought
				const sortable_table = new SourTable(table, [2, 3], {col_4: 'data-sort-value'});
				sortable_table.initiate();
			}
		}
	});
});
