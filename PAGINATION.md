# Pagination in School Pulse API

This document explains how to use pagination in the School Pulse API.

## Overview

The API now supports pagination for several endpoints using the Flop library. Pagination allows you to control how many results are returned and navigate through large datasets. The school summaries endpoint is designed to be extensible for future metrics beyond just teacher counts.

## Supported Endpoints

### 1. List Schools (`GET /api/schools`)

Returns a paginated list of schools.

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `page_size` (optional): Number of items per page (default: 20)

**Example Request:**
```
GET /api/schools?page=1&page_size=10
```

**Response Structure:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "School Name"
    }
  ],
  "meta": {
    "current_page": 1,
    "page_size": 10,
    "total_count": 25,
    "total_pages": 3
  }
}
```

### 2. School Summaries (`GET /api/schools/summaries`)

Returns schools with summaries (currently teacher counts), supporting pagination.

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `page_size` (optional): Number of items per page (default: 20)

**Example Request:**
```
GET /api/schools/summaries?page=1&page_size=5
```

**Response Structure:**
```json
{
  "data": [
    {
      "school": {
        "id": "uuid",
        "name": "School Name"
      },
      "teacher_count": 15
    }
  ],
  "meta": {
    "current_page": 1,
    "page_size": 5,
    "total_count": 25,
    "total_pages": 5
  }
}
```

## Pagination Metadata

The `meta` object in responses contains:

- `current_page`: Current page number
- `page_size`: Number of items per page
- `total_count`: Total number of items across all pages
- `total_pages`: Total number of pages
- `has_next_page`: Boolean indicating if there's a next page
- `has_previous_page`: Boolean indicating if there's a previous page

## Default Values

- **Page**: 1 (first page)
- **Page Size**: 20 items per page

## Error Handling

If invalid pagination parameters are provided, the API will return a 400 Bad Request error with details about the validation failure.

## Backward Compatibility

All endpoints maintain backward compatibility. If no pagination parameters are provided, the endpoints will return all results as before.

## Implementation Details

Pagination is implemented using the Flop library, which provides:
- Efficient database queries with LIMIT and OFFSET
- Parameter validation
- Consistent response structure
- Support for sorting and filtering (future enhancement)
