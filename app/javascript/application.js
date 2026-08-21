// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
// Sortable wishlist tables
// I've encountered errors with this library, so I'm intentionally using the unminified version
import 'sourtable'

const LOWEST_ITEM_PRIORITY = (2 ** 31 ) - 1;

// All these turbo events are ways a page can load
['turbo:load', 'turbo:render', 'turbo:morph'].forEach(turbo_event => {
	document.addEventListener(turbo_event, function() {
		// User registration: Show and hide family fields
		// Hide the family ID field if creating a new family
		// Hide the family name field if joining an existing family
		const familyCodeField = document.getElementById('family-code-field');
		const familyNameField = document.getElementById('family-name-field');

		if (familyCodeField && familyNameField) {
			const newFamilyTriggers = document.querySelector('[data-action="new-family"]')
			newFamilyTriggers.addEventListener('click', function() {
			  familyCodeField.classList.add('d-none');
			  familyNameField.classList.remove('d-none');
			});

			const existingFamilyTriggers = document.querySelector('[data-action="existing-family"]')
			existingFamilyTriggers.addEventListener('click', function() {
			  familyCodeField.classList.remove('d-none');
			  familyNameField.classList.add('d-none');
			});
		}

		// Home page: Sortable wishlist tables
		for (const table of document.querySelectorAll('.item-output-table')) {
			if (!table.classList.contains('sourtable-initiated')) {
				// [3, 4] indicates Description and Link should not be sortable
				// col_5 identifies Bought
				const sortable_table = new SourTable(table, [3, 4], {col_5: 'data-sort-value'});
				// By default SourTable removes all dollar signs and parses the remaining string as a number if possible
				// It also assumes that if the first value in a column is a number, all values in that column should be sorted as numbers
				// This means we need custom parsers whenever we want a mix of numbers and empty cells or a mix of numbers and strings
				// Priority: Treat empty cells as a very low (numerically high) priority
				sortable_table.addCustomParseFunction(0, parsePriority);
				// Price: Bypass the float parsing, and allow a mix of numbers, number ranges (like "$10 - 15"), and arbitrary strings
				sortable_table.addCustomParseFunction(2, parsePrice);
				sortable_table.initiate();
				// Automatically sort by priority when the page loads
				sortable_table.sort(0, 'asc');
			}
		}
	});
});

function parsePriority(text) {
	if (text) {
		return parseInt(text);
	}
	else {
		return LOWEST_ITEM_PRIORITY;
	}
}

function parsePrice(text) {
	// Remove the "$" prefix
	text = text.slice(1);
	let num;
	if (text.includes('-')) {
		const range = text.split('-', 2);
		const rangeStart = numberOrInfinity(range[0]);
		const rangeEnd = numberOrInfinity(range[1]);
		num = (rangeStart + rangeEnd) / 2;
	}
	else {
		// Assign arbitrary strings a value of Infinity so that they are put last when sorting
		num = numberOrInfinity(text);
	}
	return num;
}

function numberOrInfinity(text) {
	// parseFloat never throws
	let num = parseFloat(text);
	if (isNaN(num)) {
		num = Infinity;
	}
	return num;
}
