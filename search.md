---
layout: page
title: Search
permalink: /search/
---


<!-- HTML elements for search -->
<input type="text" id="search-input" placeholder="Enter search..">
<ul id="results-container"></ul>

<!-- or without installing anything -->
<script src="https://unpkg.com/simple-jekyll-search@latest/dest/simple-jekyll-search.min.js"></script>
<script>SimpleJekyllSearch({
  searchInput: document.getElementById('search-input'),
  resultsContainer: document.getElementById('results-container'),
  json: '/search.json',
  noResultsText: "No items found with that search term"
})</script>
