// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

const NONBREAKING_SPACE = '\u00A0';
const UP_ARROW = '\u2191';
const DOWN_ARROW = '\u2193';

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
		for (const th of document.querySelectorAll('.sortable-column')) {
			// Prevent multiple arrows from being added if multiple turbo events occur before the page is reloaded
			if (!th.dataset.sorting) {
				th.dataset.sorting = 'true';
				th.addEventListener('click', function(ev) {sortByColumn(ev.target)});
				th.textContent += NONBREAKING_SPACE;

				let arrowSpan = document.createElement('span');
				arrowSpan.classList.add('sort-arrow');
				arrowSpan.textContent = NONBREAKING_SPACE;
				th.appendChild(arrowSpan);
			}
		}
	});
});

function sortByColumn(th) {
	const table = th.closest('table');
	const sortArrow = th.querySelector('.sort-arrow');
	let ascending = sortArrow.textContent != UP_ARROW;

	// Read data from table
	const data = new Array();
	// Assume the first row is headings and skip it
	const trs = Object.values(table.rows).slice(1);
	for (const tr of trs) {
		data.push(new Array());
		for (const td of tr.cells) {
			data.at(-1).push(td.innerHTML);
		}
	}

	// Sort data
	const columnIndex = th.cellIndex;
	function sortRows(a, b) {
		let comp = 0;
		if (a[columnIndex] < b[columnIndex]) {
			comp = -1;
		}
		else if (a[columnIndex] > b[columnIndex]) {
			comp = 1;
		}
		if (!ascending) {
			comp = -comp;
		}
		return comp;
	}

	data.sort(sortRows);

	// Write data back into table
	for (let i = 0; i < trs.length; i++) {
		const tds = trs[i].cells;
		for (let j = 0; j < tds.length; j++) {
			tds[j].innerHTML = data[i][j];
		}
	}

	sortArrow.textContent = ascending ? UP_ARROW : DOWN_ARROW;
}
