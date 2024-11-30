#!/bin/bash
# Reset credentials to original values (if captured earlier)
if [[ -n "$OLD_AWS_ACCESS_KEY_ID" && -n "$OLD_AWS_SECRET_ACCESS_KEY" ]]; then
  export AWS_ACCESS_KEY_ID="$OLD_AWS_ACCESS_KEY_ID"
  export AWS_SECRET_ACCESS_KEY="$OLD_AWS_SECRET_ACCESS_KEY"
  export AWS_SESSION_TOKEN="$OLD_AWS_SESSION_TOKEN"
  echo "Original credentials restored."
else
  echo "No original credentials found to restore."
fi
