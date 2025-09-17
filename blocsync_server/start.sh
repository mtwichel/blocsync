if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi


dart_frog dev