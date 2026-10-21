import { broadcastResponseToMainFrame } from '@azure/msal-browser/redirect-bridge';
broadcastResponseToMainFrame().catch(() => { document.body.textContent = 'Sign-in return failed. Close this window and retry from Role Patrol.'; });
