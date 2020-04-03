import buildWorldFactory from '@theludd/gaius-cucumber'
import { createMemDb, createKvDb } from '@theludd/gaius-db-spec'

function createEnv () {
  return {
    db: createMemDb(),
    kvDB: createKvDb(),
  }
}

buildWorldFactory(createEnv)
