import * as admin from "firebase-admin";

admin.initializeApp();

export { askScience, getAiChatUsageStatus } from "./aiChat";
export { identifyCreature } from "./creatureId";
