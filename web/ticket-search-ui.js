/*
 * Role Patrol — Enterprise AI Search
 * Unified governance search across Business Roles, Entitlements, and Tickets.
 * Powered by Azure AI Search and deterministic SQL governance via Logic App Gateway.
 */
(() => {
  function escapeHtml(str) {
    if (!str) return '';
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }

  // Inject Launcher into Header
  function injectLauncher() {
    const headerAuth = document.querySelector('.header-auth');
    if (!headerAuth || document.getElementById('rpAiSearchOpen')) return;

    const launchBtn = document.createElement('button');
    launchBtn.id = 'rpAiSearchOpen';
    launchBtn.type = 'button';
    launchBtn.innerHTML = `<span>🔍</span> AI Search`;
    launchBtn.style.cssText = 'background: #0f766e; color: #fff; border: 1px solid rgba(255,255,255,0.25); border-radius: 6px; padding: 7px 14px; font-weight: 600; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); transition: background 0.15s; font-size: 0.84rem;';
    launchBtn.onmouseenter = () => { launchBtn.style.background = '#0d9488'; };
    launchBtn.onmouseleave = () => { launchBtn.style.background = '#0f766e'; };
    launchBtn.onclick = () => openModal();
    headerAuth.prepend(launchBtn);
  }

  // Hook into View Mode Switcher
  function hookViewModeBar() {
    const toggle = document.querySelector('.view-mode-toggle');
    if (toggle && !document.getElementById('btnViewSearch')) {
      const searchTab = document.createElement('button');
      searchTab.id = 'btnViewSearch';
      searchTab.type = 'button';
      searchTab.className = 'view-btn';
      searchTab.innerHTML = `<span>🔍</span> AI Search`;
      searchTab.onclick = () => openModal();
      toggle.append(searchTab);
    }
  }

  // Build the Minimalist Modal UI
  const modal = document.createElement('div');
  modal.id = 'rpAiSearchModal';
  modal.setAttribute('role', 'dialog');
  modal.setAttribute('aria-modal', 'true');
  modal.style.cssText = 'display:none;position:fixed;inset:0;z-index:10000;background:rgba(15,23,42,0.6);backdrop-filter:blur(4px);padding:4vh 20px;overflow:auto;animation:fadeIn 0.15s ease-out;';

  const panel = document.createElement('div');
  panel.style.cssText = 'max-width:880px;margin:0 auto;background:#ffffff;border-radius:12px;box-shadow:0 20px 50px rgba(15,23,42,0.25);color:#1e293b;border:1px solid #cbd5e1;overflow:hidden;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;';

  // 1. Header
  const header = document.createElement('div');
  header.style.cssText = 'padding:18px 24px;border-bottom:1px solid #e2e8f0;background:#f8fafc;display:flex;justify-content:space-between;align-items:center;';
  header.innerHTML = `
    <div>
      <h2 style="margin:0;font-size:1.2rem;font-weight:700;color:#0f172a;display:flex;align-items:center;gap:8px;">
        🔍 AI Governance Search
      </h2>
      <p style="margin:2px 0 0 0;font-size:0.82rem;color:#64748b;">
        Azure AI Search semantic query across 600 verified tickets with deterministic SQL attribution
      </p>
    </div>
    <button id="btnAiSearchClose" style="background:white;border:1px solid #cbd5e1;color:#64748b;border-radius:6px;width:32px;height:32px;cursor:pointer;font-weight:700;font-size:0.9rem;">✕</button>
  `;
  panel.append(header);

  // 2. Search Box Container
  const searchSection = document.createElement('div');
  searchSection.style.cssText = 'padding:20px 24px 14px 24px;border-bottom:1px solid #e2e8f0;';

  const inputWrap = document.createElement('div');
  inputWrap.style.cssText = 'display:flex;align-items:center;background:#ffffff;border:2px solid #0f766e;border-radius:8px;padding:4px 8px;gap:8px;box-shadow:0 1px 3px rgba(15,118,110,0.1);';

  const searchIcon = document.createElement('span');
  searchIcon.style.cssText = 'font-size:1.1rem;padding-left:8px;color:#0f766e;';
  searchIcon.textContent = '🔍';

  const queryInput = document.createElement('input');
  queryInput.type = 'search';
  queryInput.placeholder = 'Search by role (e.g. Credit Review, BR0008), entitlement (ENT0140), app, or complaint text...';
  queryInput.style.cssText = 'flex:1;border:none;outline:none;font-size:0.95rem;padding:8px 6px;color:#0f172a;background:transparent;';

  const btnSearch = document.createElement('button');
  btnSearch.textContent = 'Search';
  btnSearch.style.cssText = 'background:#0f766e;color:white;border:none;border-radius:6px;padding:8px 18px;font-size:0.86rem;font-weight:700;cursor:pointer;transition:background 0.15s;';
  btnSearch.onmouseenter = () => { btnSearch.style.background = '#0d9488'; };
  btnSearch.onmouseleave = () => { btnSearch.style.background = '#0f766e'; };

  inputWrap.append(searchIcon, queryInput, btnSearch);
  searchSection.append(inputWrap);

  // Quick Suggestions
  const quickRow = document.createElement('div');
  quickRow.style.cssText = 'display:flex;align-items:center;gap:8px;margin-top:12px;flex-wrap:wrap;';
  const quickLabel = document.createElement('span');
  quickLabel.style.cssText = 'font-size:0.75rem;font-weight:700;color:#64748b;text-transform:uppercase;letter-spacing:0.04em;';
  quickLabel.textContent = 'Quick Queries:';
  quickRow.append(quickLabel);

  const quickPills = [
    { label: 'Access to Exception Review', q: 'access to exception review' },
    { label: 'Credit Review Specialist (BR0008)', q: 'Credit Review Specialist' },
    { label: 'Payment Operations (BR0005)', q: 'Payment Operations' },
    { label: 'Missing Work Queue permission', q: 'missing work queue permission' },
    { label: 'Document Control (BR0039)', q: 'Document Control' }
  ];

  quickPills.forEach(p => {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.textContent = p.label;
    btn.style.cssText = 'background:#f1f5f9;border:1px solid #e2e8f0;border-radius:14px;padding:3px 10px;font-size:0.78rem;font-weight:600;color:#334155;cursor:pointer;transition:all 0.15s;';
    btn.onmouseenter = () => { btn.style.background = '#e2e8f0'; btn.style.color = '#0f172a'; };
    btn.onmouseleave = () => { btn.style.background = '#f1f5f9'; btn.style.color = '#334155'; };
    btn.onclick = () => {
      queryInput.value = p.q;
      performUnifiedSearch(p.q);
    };
    quickRow.append(btn);
  });
  searchSection.append(quickRow);
  panel.append(searchSection);

  // 3. Category Filter Tabs Row
  const filterTabsRow = document.createElement('div');
  filterTabsRow.style.cssText = 'display:flex;padding:0 24px;border-bottom:1px solid #e2e8f0;background:#fbfcfe;gap:4px;';
  panel.append(filterTabsRow);

  // 4. Results Area
  const resultsArea = document.createElement('div');
  resultsArea.style.cssText = 'padding:20px 24px;max-height:60vh;overflow-y:auto;display:flex;flex-direction:column;gap:12px;';
  panel.append(resultsArea);

  modal.append(panel);
  document.body.append(modal);

  // State
  let currentSearchResults = { roles: [], entitlements: [], tickets: [], query: '', notice: '' };
  let activeTab = 'all'; // 'all' | 'roles' | 'entitlements' | 'tickets'

  header.querySelector('#btnAiSearchClose').onclick = () => { modal.style.display = 'none'; };
  modal.addEventListener('click', e => { if (e.target === modal) modal.style.display = 'none'; });

  btnSearch.onclick = () => performUnifiedSearch(queryInput.value.trim());
  queryInput.onkeydown = e => { if (e.key === 'Enter') { e.preventDefault(); performUnifiedSearch(queryInput.value.trim()); } };

  function openModal() {
    modal.style.display = 'block';
    queryInput.focus();
    if (!queryInput.value) {
      queryInput.value = 'access exception';
      performUnifiedSearch('access exception');
    }
  }

  function navigateToRole(roleId) {
    modal.style.display = 'none';
    if (window.RolePatrolAPI?.inspectRole) {
      window.RolePatrolAPI.inspectRole(roleId);
    }
  }

  async function performUnifiedSearch(query) {
    if (!query) return;
    const qLower = query.toLowerCase();

    // Check auth
    if (!window.RolePatrolAPI?.getAccount?.()) {
      resultsArea.replaceChildren();
      const authNotice = document.createElement('div');
      authNotice.style.cssText = 'text-align:center;padding:32px;color:#1e40af;background:#eff6ff;border:1px solid #bfdbfe;border-radius:8px;';
      authNotice.innerHTML = `
        <h4 style="margin:0 0 6px 0;font-size:1rem;">🔐 Sign-in Required</h4>
        <p style="margin:0;font-size:0.86rem;color:#3b82f6;">
          Please sign in with your Role Owner account to run Azure AI Search queries through the secure Logic App API gateway.
        </p>
      `;
      resultsArea.append(authNotice);
      return;
    }

    resultsArea.replaceChildren();
    const loading = document.createElement('div');
    loading.style.cssText = 'text-align:center;padding:28px;color:#0f766e;font-weight:600;font-size:0.9rem;';
    loading.textContent = `Searching Azure AI Search index 'ticket-text' & attributing via SQL…`;
    resultsArea.append(loading);

    // 1. Search Live Roles
    const allRoles = window.RolePatrolAPI?.getAllRoles() || [];
    const keywords = qLower.split(/\s+/).filter(w => w.length > 2 && !['and', 'for', 'the', 'with', 'under'].includes(w));
    const matchedRoles = allRoles.filter(r => {
      const rText = `${r.RoleId || ''} ${r.JobTitle || ''} ${r.Department || ''} ${r.CostCenter || ''} ${r.Region || ''}`.toLowerCase();
      if (rText.includes(qLower)) return true;
      if (keywords.length > 0 && keywords.some(k => rText.includes(k) && !['missing', 'access', 'permission'].includes(k))) return true;
      return false;
    });

    // 2. Search Live Entitlements & Applications
    const entCatalog = window.RolePatrolAPI?.getEntitlementCatalog ? window.RolePatrolAPI.getEntitlementCatalog() : {};
    const matchedEntitlements = Object.keys(entCatalog).map(k => ({ id: k, ...entCatalog[k] })).filter(e => {
      const eText = `${e.id || ''} ${e.name || ''} ${e.description || ''} ${(e.applications || []).join(' ')} ${e.risk || ''}`.toLowerCase();
      if (eText.includes(qLower)) return true;
      if (keywords.length > 0 && keywords.some(k => eText.includes(k) && k !== 'missing')) return true;
      return false;
    });

    // 3. Search Tickets via Logic App Gateway (Azure AI Search + SQL Attribution)
    let matchedTickets = [];
    let searchNotice = '';
    try {
      const res = await window.RolePatrolAPI.call({
        op: 'ticketSearch',
        query: query,
        groupBy: 'Role',
        searchMode: 'Semantic'
      });
      const candidates = res?.candidates || res?.confirmedResults || [];
      searchNotice = res?.notice || '';
      matchedTickets = candidates.map(c => ({
        candidateId: c.CandidateId,
        ticketId: c.TicketId,
        text: c.TicketText,
        role: c.RoleId,
        title: c.JobTitle,
        country: c.Country || 'US',
        status: c.Status,
        rank: c.SearchRank,
        canConfirm: c.canConfirm
      }));
    } catch (err) {
      console.warn('AI search request failed', err);
      searchNotice = `Search query notice: ${err.message || 'Ticket search service returned no candidates.'}`;
    }

    currentSearchResults = {
      query,
      roles: matchedRoles,
      entitlements: matchedEntitlements,
      tickets: matchedTickets,
      notice: searchNotice
    };

    activeTab = 'all';
    renderFilterTabs();
    renderFilteredResults();
  }

  function renderFilterTabs() {
    filterTabsRow.replaceChildren();

    const { roles, entitlements, tickets } = currentSearchResults;
    const totalCount = roles.length + entitlements.length + tickets.length;

    const tabs = [
      { id: 'all', label: `All (${totalCount})` },
      { id: 'roles', label: `🏢 Roles (${roles.length})` },
      { id: 'entitlements', label: `🔑 Entitlements (${entitlements.length})` },
      { id: 'tickets', label: `🎫 Tickets (${tickets.length})` }
    ];

    tabs.forEach(t => {
      const btn = document.createElement('button');
      btn.type = 'button';
      btn.textContent = t.label;
      const isActive = activeTab === t.id;
      btn.style.cssText = `padding: 10px 14px; border: none; background: transparent; font-size: 0.82rem; font-weight: 600; cursor: pointer; border-bottom: 3px solid ${isActive ? '#0f766e' : 'transparent'}; color: ${isActive ? '#0f766e' : '#64748b'}; transition: all 0.15s;`;
      btn.onclick = () => {
        activeTab = t.id;
        renderFilterTabs();
        renderFilteredResults();
      };
      filterTabsRow.append(btn);
    });
  }

  function renderFilteredResults() {
    resultsArea.replaceChildren();

    const { query, roles, entitlements, tickets, notice } = currentSearchResults;

    // 1. Executive Grounded Answer Banner
    if (query && (roles.length > 0 || tickets.length > 0)) {
      const execBox = document.createElement('div');
      execBox.style.cssText = 'background:#f0fdf4;border:1px solid #bbf7d0;border-left:4px solid #16a34a;border-radius:8px;padding:12px 16px;margin-bottom:12px;';
      
      let insightText = '';
      if (roles.length > 0) {
        const topRole = roles[0];
        insightText = `🎯 <strong>Live SQL Governance Insight:</strong> Matched business role <strong>${escapeHtml(topRole.JobTitle || topRole.RoleId)} (${escapeHtml(topRole.RoleId)})</strong> in ${escapeHtml(topRole.Region || 'US')} (${escapeHtml(topRole.Department || 'Operations')}). ${topRole.HasFriction ? `Flagged with ${topRole.AffectedEmployees || 0} friction cases.` : 'Verified clean baseline posture.'}`;
      } else if (tickets.length > 0) {
        const topTicket = tickets[0];
        insightText = `🎯 <strong>AI Search Insight:</strong> Found ticket <strong>${escapeHtml(topTicket.ticketId)}</strong> attributed to role <strong>${escapeHtml(topTicket.role)}</strong> (${escapeHtml(topTicket.country)}): "${escapeHtml(topTicket.text)}".`;
      }

      execBox.innerHTML = `
        <div style="font-size:0.88rem;color:#14532d;line-height:1.45;">${insightText}</div>
        ${notice ? `<div style="font-size:0.78rem;color:#15803d;margin-top:4px;opacity:0.9;">ℹ️ ${escapeHtml(notice)}</div>` : ''}
      `;
      resultsArea.append(execBox);
    }

    const showAll = activeTab === 'all';

    // 2. Roles Results
    if ((showAll || activeTab === 'roles') && roles.length > 0) {
      roles.forEach(r => {
        const card = document.createElement('div');
        card.style.cssText = 'background:#ffffff;border:1px solid #e2e8f0;border-radius:8px;padding:14px 16px;box-shadow:0 1px 2px rgba(0,0,0,0.03);display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;';
        card.innerHTML = `
          <div>
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:3px;">
              <span style="background:#e0f2fe;color:#0369a1;font-size:0.72rem;font-weight:700;padding:2px 8px;border-radius:12px;text-transform:uppercase;">🏢 Business Role</span>
              <strong style="color:#0f172a;font-size:0.95rem;">${escapeHtml(r.JobTitle)} (${escapeHtml(r.RoleId)})</strong>
            </div>
            <div style="font-size:0.8rem;color:#64748b;">
              Cost Center: ${r.CostCenter || 'N/A'} · Region: ${r.Region || 'US'} · Department: ${r.Department || 'N/A'}
            </div>
            <div style="font-size:0.82rem;color:${r.HasFriction ? '#b91c1c' : '#15803d'};font-weight:600;margin-top:4px;">
              ${r.HasFriction ? `⚠️ ${r.AffectedEmployees} transferred staff blocked (${r.FrictionRatio}% friction) · Priority Rank #${r.PriorityRank}` : `✅ Clean baseline · 0% mover friction`}
            </div>
          </div>
          <button class="ai-inspect-btn" style="background:#0f766e;color:white;border:none;border-radius:6px;padding:8px 14px;font-size:0.82rem;font-weight:600;cursor:pointer;">
            Inspect Role Evidence →
          </button>
        `;
        card.querySelector('.ai-inspect-btn').onclick = () => navigateToRole(r.RoleId);
        resultsArea.append(card);
      });
    }

    // 3. Entitlements & Applications Results
    if ((showAll || activeTab === 'entitlements') && entitlements.length > 0) {
      entitlements.forEach(e => {
        const card = document.createElement('div');
        card.style.cssText = 'background:#ffffff;border:1px solid #e2e8f0;border-radius:8px;padding:14px 16px;box-shadow:0 1px 2px rgba(0,0,0,0.03);display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;';
        card.innerHTML = `
          <div style="flex:1;min-width:280px;">
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:4px;">
              <span style="background:#fef3c7;color:#92400e;font-size:0.72rem;font-weight:700;padding:2px 8px;border-radius:12px;text-transform:uppercase;">🔑 Entitlement</span>
              <strong style="color:#0f172a;font-size:0.95rem;">${escapeHtml(e.id)} · ${escapeHtml(e.name)}</strong>
              <span style="font-size:0.74rem;color:#64748b;font-weight:600;">(${escapeHtml(e.risk)})</span>
            </div>
            <div style="display:flex;flex-wrap:wrap;gap:6px;margin:6px 0;">
              ${(e.applications || []).map(app => `<span style="background:#f0fdf4;border:1px solid #86efac;color:#15803d;font-size:0.76rem;font-weight:600;padding:2px 8px;border-radius:10px;">💻 ${escapeHtml(app)}</span>`).join('')}
            </div>
            <div style="font-size:0.8rem;color:#475569;">${escapeHtml(e.description || '')}</div>
          </div>
        `;
        resultsArea.append(card);
      });
    }

    // 4. Tickets Results (Azure AI Search candidates)
    if ((showAll || activeTab === 'tickets') && tickets.length > 0) {
      tickets.forEach(t => {
        const card = document.createElement('div');
        card.style.cssText = 'background:#ffffff;border:1px solid #e2e8f0;border-radius:8px;padding:14px 16px;box-shadow:0 1px 2px rgba(0,0,0,0.03);display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;';
        card.innerHTML = `
          <div style="flex:1;min-width:280px;">
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:4px;">
              <span style="background:#fee2e2;color:#991b1b;font-size:0.72rem;font-weight:700;padding:2px 8px;border-radius:12px;text-transform:uppercase;">🎫 AI Search Match</span>
              <strong style="color:#0f172a;font-size:0.95rem;">${escapeHtml(t.ticketId)}</strong>
              <span style="background:#e0f2fe;color:#0369a1;padding:2px 6px;border-radius:4px;font-size:0.75rem;font-weight:600;">Role: ${escapeHtml(t.role)} (${escapeHtml(t.country)})</span>
              <span style="color:#64748b;font-size:0.78rem;">${escapeHtml(t.title || '')}</span>
            </div>
            <div style="font-size:0.86rem;color:#334155;background:#f8fafc;padding:6px 10px;border-radius:6px;border-left:3px solid #0f766e;margin-top:4px;">
              "${escapeHtml(t.text)}"
            </div>
          </div>
          <button class="ai-inspect-btn" style="background:#0f766e;color:white;border:none;border-radius:6px;padding:8px 14px;font-size:0.82rem;font-weight:600;cursor:pointer;">
            Inspect Role (${t.role}) →
          </button>
        `;
        card.querySelector('.ai-inspect-btn').onclick = () => navigateToRole(t.role);
        resultsArea.append(card);
      });
    }

    // Empty state
    const totalShown = (showAll ? (roles.length + entitlements.length + tickets.length) :
      (activeTab === 'roles' ? roles.length :
       activeTab === 'entitlements' ? entitlements.length : tickets.length));

    if (totalShown === 0) {
      const empty = document.createElement('div');
      empty.style.cssText = 'text-align:center;padding:36px;color:#64748b;font-size:0.9rem;';
      empty.textContent = `No items found matching "${query}" in this category.`;
      resultsArea.append(empty);
    }
  }

  // Periodic injector check
  injectLauncher();
  hookViewModeBar();
  setInterval(() => {
    injectLauncher();
    hookViewModeBar();
  }, 1000);
})();
