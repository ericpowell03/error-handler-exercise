# Error Handler

## Background
You are in a situation where you have an application that frequently raises **expected** exceptions that should be rescued.
While you have set up an error monitoring service such as [Sentry](https://sentry.io) or [Bugsnag](https://www.bugsnag.com/),
you don't want a notification every time these **expected** exceptions happen.
You want to be able to focus on high priority exceptions that may indicate a real problem.

Using begin/rescue everywhere in the codebase isn't ideal because:

- Many of the same **expected** exceptions are raised in different parts of the codebase. Using begin/rescue in all these areas would cause a lot of duplication.
- You want to standardize the way these exceptions are rescued for consistency and readability.
- You want to conditionally rescue exceptions based on attributes of the error instance.

## Task
- Create a feature branch from `main`.
- Given the background above, architect a solution for providing an abstraction for rescuing these **expected** exceptions throughout your application. There is a module named [ErrorHandler](lib/error_handler.rb) in the `lib` directory as a starting point. The `ErrorHandler` module has a `#handle_errors` method that should accept a block of code to execute. If the block raises an exception, it should be conditionally rescued.
- You should implement `ErrorHandler` such that users of the module can configure rules for conditionally rescuing exceptions when using `#handle_errors`. You must allow for users of the module to rescue exceptions based on the exception class type, the exception message, or any arbitrary attribute of the exception instance.
- You should allow users of the module to configure multiple rules. They shouldn't be limited to just one.
- Your solution should be easily reusable and configurable. It's important to keep in mind that you might want to swallow a specific error in one part of the codebase and not another. Therefore, **only** allowing for global rules for the entire codebase is not ideal. It's ideal to be able to configure rules at the class level (that the module is included in) and also to supersede those rules on a per use basis (when calling `#handle_errors`).

## Submission Details
- Please include documentation for how to use this abstraction with examples and use comments to describe why you made particular design decisions.
- Please provide tests for your work in the [spec](spec) directory.
- Please treat commits and commit messages as if they were going to be merged into a shared team repo and deployed to production, paying attention to formatting and content. As a reference, we follow [these guidelines](https://chris.beams.io/posts/git-commit/).
- When you are ready, please submit a pull request in the repo using the [provided pull request template](.github/PULL_REQUEST_TEMPLATE/FEATURE.md).
- If you are making any assumptions surrounding your work, please state these in your pull request.
- Please be detailed in your pull request, explaining the decisions you've made as well as the advantages and disadvantages of your solution.
- Please don't spend more than 1 - 2 hours on your solution.

## Things to Avoid
- Please avoid leveraging gems to do the bulk of the work. Although we agree with the sentiment of not reinventing the wheel, for the purposes of this assignment, we are more interested in seeing original work.


## Other Considerations
Note that a spike in these **expected** exceptions may indicate an actual problem and potentially downtime of some third-party service.
However, you are tracking this via some other method such as logging, statsd, etc. So this is not a concern for this assignment.

Please let us know if you have any questions by [opening an Issue](../../issues/new) in this repo and we will respond as soon as possible (we use Github issues as our primary mode of asynchronous communication around engineering tasks unless something is urgent).

## Evaluation Criteria
- Solution chosen
- Ruby syntax conventions
- Git commit messages
- Pull request description
- RSpec test coverage and organization
