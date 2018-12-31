# Features

This service collects data from Pivotal Tracker.
It extends Pivotal Tracker's APIs by returning a historical snapshots of the endpoints.

Currently supported endpoints

- [Stories](https://www.pivotaltracker.com/help/api/rest/v5#Stories)

# Test
## Stubs

We use [a demo project](https://www.pivotaltracker.com/n/projects/2200655) for testing.
The values can be found in `spec/fixtures/files`.

Current files are created from data fetched on 2018/12/30.

**Tests check values in the fixture files.  You should not change the files.**

# Tech Log
## Testing

- Use [Webmock](https://github.com/bblimke/webmock) to stub API queries.