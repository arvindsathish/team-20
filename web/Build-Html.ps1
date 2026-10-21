param([Parameter(Mandatory)][string]$ConfigFile)
$ErrorActionPreference='Stop'
$config=Get-Content -LiteralPath $ConfigFile -Raw|ConvertFrom-Json
if(($config|ConvertTo-Json -Depth 10) -match 'REPLACE_'){throw 'Complete config values before building.'}
$app=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'dist/app.js'), [Text.Encoding]::UTF8)
$ticketSearch=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'ticket-search-ui.js'), [Text.Encoding]::UTF8)
$bridge=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'dist/bridge.js'), [Text.Encoding]::UTF8)
$cfg=($config|ConvertTo-Json -Depth 20 -Compress).Replace('<','\u003c')

$css=@'
:root {
  --primary: #1559bd;
  --primary-hover: #0f4699;
  --bg-main: #f4f7fb;
  --surface: #ffffff;
  --text-main: #17243b;
  --text-muted: #5a6e85;
  --border: #dbe3ed;
  --card-shadow: 0 3px 12px rgba(23, 36, 59, 0.06);
}
* { box-sizing: border-box; }
body { font: 15px -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, sans-serif; background: var(--bg-main); color: var(--text-main); margin: 0; line-height: 1.5; }

/* Header */
header { background: #111e38; color: white; padding: 18px 32px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 8px rgba(0,0,0,0.15); flex-wrap: wrap; gap: 12px; }
.header-brand h1 { margin: 0; font-size: 1.45rem; font-weight: 700; letter-spacing: -0.02em; display: flex; align-items: center; gap: 8px; }
.header-brand small { color: #9ab3d1; font-size: 0.82rem; display: block; margin-top: 3px; }
.header-auth { display: flex; align-items: center; gap: 12px; }
.header-auth button { font-weight: 600; font-size: 0.84rem; padding: 7px 16px; border-radius: 6px; cursor: pointer; transition: all 0.15s; }
.user-chip { background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.18); padding: 6px 14px; border-radius: 20px; font-size: 0.82rem; display: flex; align-items: center; gap: 8px; color: #e1ebf7; }
.user-dot { width: 8px; height: 8px; background: #10b981; border-radius: 50%; box-shadow: 0 0 6px #10b981; }
#signin { background: #2563eb; color: white; border: 1px solid rgba(255,255,255,0.25); }
#signin:hover:not(:disabled) { background: #1d4ed8; }
#signout { background: rgba(239, 68, 68, 0.15); border: 1px solid rgba(239, 68, 68, 0.4); color: #fca5a5; }
#signout:hover:not(:disabled) { background: rgba(239, 68, 68, 0.3); color: #ffffff; }

/* Main Wrapper */
main { max-width: 1340px; margin: 0 auto; padding: 24px 28px; }

/* Status message */
#message { padding: 12px 18px; background: #e8f0fe; color: #174ea6; border-radius: 8px; margin: 0 0 16px 0; font-size: 0.88rem; font-weight: 500; display: none; }
#message:not(:empty) { display: block; }

/* View Mode Segmented Switcher */
.view-mode-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 12px; background: white; padding: 10px 18px; border-radius: 10px; border: 1px solid var(--border); box-shadow: 0 1px 3px rgba(0,0,0,0.03); }
.view-mode-toggle { background: #e2e8f0; padding: 4px; border-radius: 24px; display: inline-flex; gap: 4px; }
.view-btn { border: none; background: transparent; padding: 8px 18px; border-radius: 20px; font-size: 0.88rem; font-weight: 600; color: #475569; cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; gap: 6px; }
.view-btn:hover { color: #1e293b; }
.view-btn.active { background: #111e38; color: white; box-shadow: 0 2px 6px rgba(17,30,56,0.2); }
.view-mode-hint { font-size: 0.82rem; color: #64748b; font-weight: 500; }

/* Simplified View: Executive Pulse Card */
.exec-pulse-card { background: white; border: 1px solid var(--border); border-radius: 12px; padding: 20px 24px; margin-bottom: 20px; box-shadow: var(--card-shadow); display: grid; grid-template-columns: minmax(360px, 1.4fr) minmax(280px, 1.1fr) auto; gap: 24px; align-items: center; }
@media (max-width: 1024px) { .exec-pulse-card { grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); } }
.pulse-metric { display: flex; flex-direction: column; gap: 4px; }
.pulse-chart-metric { display: flex; flex-direction: row; align-items: center; gap: 18px; }
.pulse-chart-wrap { flex-shrink: 0; width: 88px; height: 88px; display: flex; align-items: center; justify-content: center; position: relative; }
.pulse-pie-slice { transition: opacity 0.15s, stroke-width 0.15s; }
.pulse-pie-slice:hover { opacity: 0.85; stroke-width: 13; }
.pulse-chart-info { display: flex; flex-direction: column; gap: 4px; min-width: 0; }
.pulse-health-legend { display: flex; flex-direction: column; gap: 4px; margin: 3px 0; }
.pulse-legend-item { display: flex; align-items: baseline; gap: 8px; }
.pulse-legend-badge { width: 10px; height: 10px; border-radius: 50%; display: inline-block; flex-shrink: 0; margin-top: 2px; }
.pulse-legend-badge.badge-clean { background: #16a34a; box-shadow: 0 0 0 2px rgba(22, 163, 74, 0.2); }
.pulse-legend-badge.badge-warn { background: #dc2626; box-shadow: 0 0 0 2px rgba(220, 38, 38, 0.2); }
.pulse-label { text-transform: uppercase; font-size: 0.74rem; font-weight: 700; letter-spacing: 0.05em; color: var(--text-muted); }
.pulse-val { font-size: 1.25rem; font-weight: 800; display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
.pulse-clean { color: #15803d; }
.pulse-warn { color: #c81e1e; }
.pulse-sep { color: #cbd5e1; font-weight: 400; }
.pulse-highlight { color: #1e40af; }
.pulse-sub { font-size: 0.8rem; color: var(--text-muted); }
.pulse-cta { display: flex; align-items: flex-end; justify-content: flex-end; }
@media (max-width: 768px) { .pulse-cta { justify-content: flex-start; } }

/* Simplified View: Spotlight Hero Card */
.exec-spotlight-card { background: linear-gradient(135deg, #f0fdf4 0%, #ffffff 100%); border: 1px solid #bbf7d0; border-left: 5px solid #16a34a; border-radius: 10px; padding: 18px 22px; margin-bottom: 24px; box-shadow: 0 2px 8px rgba(22, 163, 74, 0.06); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; }
.spotlight-badge { font-size: 0.76rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; color: #15803d; background: #dcfce7; padding: 4px 10px; border-radius: 12px; display: inline-block; margin-bottom: 6px; }
.spotlight-title { font-size: 1.12rem; font-weight: 800; color: #0f172a; }
.spotlight-desc { font-size: 0.86rem; color: #334155; margin-top: 4px; line-height: 1.5; }
.spotlight-btn { background: #16a34a; color: white; font-weight: 700; padding: 10px 20px; font-size: 0.9rem; border: none; border-radius: 6px; box-shadow: 0 2px 6px rgba(22,163,74,0.3); cursor: pointer; transition: background 0.15s; }
.spotlight-btn:hover { background: #15803d; }

/* Simplified View: Top Roles Controls & Footer */
.simple-count-control { display: flex; align-items: center; gap: 8px; }
.simple-footer-callout { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 14px 20px; margin-top: 18px; text-align: center; font-size: 0.86rem; color: #475569; }
.simple-footer-link { cursor: pointer; color: #1d4ed8; font-weight: 600; text-decoration: underline; border: none; background: transparent; padding: 0; font-size: inherit; }
.simple-footer-link:hover { color: #1e40af; }

/* KPI Grid */
.kpi-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; margin-bottom: 24px; }
.kpi-card { background: var(--surface); border-radius: 10px; padding: 18px 20px; border: 1px solid var(--border); box-shadow: var(--card-shadow); border-top: 4px solid var(--primary); }
.kpi-card.kpi-alert { border-top-color: #ef4444; }
.kpi-card.kpi-warn { border-top-color: #f59e0b; }
.kpi-card.kpi-info { border-top-color: #0694a2; }
.kpi-label { font-size: 0.75rem; text-transform: uppercase; font-weight: 700; color: var(--text-muted); letter-spacing: 0.05em; }
.kpi-val { font-size: 1.85rem; font-weight: 800; color: var(--text-main); margin: 6px 0 2px 0; }
.kpi-sub { font-size: 0.8rem; color: var(--text-muted); }

/* Content Section */
section { background: var(--surface); border-radius: 12px; padding: 24px; margin-bottom: 24px; border: 1px solid var(--border); box-shadow: var(--card-shadow); }
.section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; flex-wrap: wrap; gap: 12px; }
.section-title h2 { margin: 0; font-size: 1.25rem; font-weight: 700; color: var(--text-main); }
.section-title p { margin: 4px 0 0 0; color: var(--text-muted); font-size: 0.86rem; }

/* Triage Bar */
.triage-bar { display: flex; gap: 12px; align-items: center; flex-wrap: wrap; margin-bottom: 18px; padding-bottom: 16px; border-bottom: 1px solid #edf2f7; }
.filter-pills { display: flex; gap: 6px; flex-wrap: wrap; }
.pill-btn { font-size: 0.8rem; padding: 6px 12px; border-radius: 20px; border: 1px solid var(--border); background: #f8fafc; color: var(--text-muted); cursor: pointer; font-weight: 500; transition: all 0.15s; }
.pill-btn:hover { background: #eef3f9; color: var(--text-main); }
.pill-btn.active { background: #111e38; color: white; border-color: #111e38; }

.search-box { position: relative; flex: 1; min-width: 200px; max-width: 300px; }
.search-input { width: 100%; padding: 7px 12px; font-size: 0.85rem; border: 1px solid var(--border); border-radius: 6px; }
.select-filter { padding: 7px 10px; font-size: 0.84rem; border: 1px solid var(--border); border-radius: 6px; background: white; color: var(--text-main); }
.toggle-wrap { display: flex; align-items: center; gap: 6px; font-size: 0.82rem; color: var(--text-muted); cursor: pointer; user-select: none; margin-left: auto; }

/* Table */
.table-wrap { width: 100%; overflow-x: auto; margin-bottom: 14px; }
table { width: 100%; border-collapse: collapse; font-size: 0.88rem; }
th, td { padding: 12px 14px; text-align: left; border-bottom: 1px solid #eef2f6; }
th { background: #f8fafc; color: #475569; font-weight: 600; font-size: 0.78rem; text-transform: uppercase; letter-spacing: 0.03em; border-top: 1px solid #edf2f7; user-select: none; }
th.sortable { cursor: pointer; }
th.sortable:hover { background: #edf2f9; color: var(--text-main); }
tr:hover td { background: #fbfcfe; }

/* Role cell */
.role-title { font-weight: 600; color: var(--text-main); font-size: 0.92rem; }
.role-sub { font-size: 0.75rem; color: var(--text-muted); margin-top: 2px; }

/* Badges */
.badge { display: inline-block; padding: 3px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; text-align: center; }
.badge-rank-alert { background: #fde8e8; color: #c81e1e; border: 1px solid #fbd5d5; }
.badge-rank-warn { background: #fef9c3; color: #854d0e; border: 1px solid #fde047; }
.badge-rank-base { background: #f1f5f9; color: #64748b; }
.badge-cov { background: #dcfce7; color: #15803d; }
.badge-cov-complete { background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
.badge-cov-partial { background: #fef3c7; color: #b45309; border: 1px solid #fde68a; }
.badge-cov-unknown { background: #f1f5f9; color: #64748b; border: 1px solid #e2e8f0; }
.badge-score-high { background: #fdf2f8; color: #9d174d; border: 1px solid #fbcfe8; font-weight: 700; }
.badge-score-mid { background: #fefce8; color: #a16207; border: 1px solid #fef08a; font-weight: 700; }
.badge-score-low { background: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; font-weight: 600; }
.badge-score-base { background: #f8fafc; color: #64748b; border: 1px solid #e2e8f0; }

.model-drawer-banner { background: #faf5ff; border: 1px solid #e9d5ff; border-left: 4px solid #9333ea; border-radius: 8px; padding: 14px 16px; margin-bottom: 20px; }
.model-badge { font-size: 0.74rem; font-weight: 700; text-transform: uppercase; color: #7e22ce; letter-spacing: 0.04em; margin-bottom: 4px; }
.model-score-row { display: flex; align-items: baseline; gap: 10px; margin: 4px 0; }
.model-score-val { font-size: 1.4rem; font-weight: 800; color: #1e1b4b; }
.model-rubric-txt { font-size: 0.88rem; font-weight: 600; color: #6b21a8; }
.model-disclaimer { font-size: 0.78rem; color: #64748b; margin-top: 6px; line-height: 1.35; }
.model-provenance-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 8px; margin: 10px 0; font-size: 0.78rem; background: rgba(255,255,255,0.75); border: 1px solid #e9d5ff; border-radius: 6px; padding: 8px 10px; }
.model-prov-item { display: flex; flex-direction: column; }
.model-prov-lbl { font-size: 0.7rem; color: #6b21a8; font-weight: 700; text-transform: uppercase; letter-spacing: 0.03em; }
.model-prov-val { color: #1e1b4b; font-weight: 600; word-break: break-all; }
.model-json-details { margin-top: 8px; padding: 10px 12px; background: #0f172a; color: #38bdf8; border-radius: 6px; font-size: 0.74rem; font-family: monospace; white-space: pre-wrap; word-break: break-all; max-height: 200px; overflow-y: auto; display: none; line-height: 1.4; border: 1px solid #334155; }

/* Source Coverage Panel */
.source-cov-panel { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 12px 14px; margin-bottom: 18px; }
.source-cov-title { font-size: 0.76rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; color: #475569; margin-bottom: 8px; display: flex; justify-content: space-between; align-items: center; }
.source-cov-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px; }
.source-cov-item { background: white; border: 1px solid #e2e8f0; border-radius: 6px; padding: 8px 10px; font-size: 0.8rem; }
.source-cov-item-name { font-weight: 600; color: #1e293b; display: flex; align-items: center; justify-content: space-between; margin-bottom: 2px; }
.source-cov-item-status { font-size: 0.73rem; color: #64748b; line-height: 1.35; }
.source-status-live { color: #15803d; font-weight: 600; }
.source-status-warn { color: #b45309; font-weight: 600; }


/* AI Grounded Evidence Summary Card */
.ai-summary-card { background: #eff6ff; border: 1px solid #bfdbfe; border-left: 4px solid #2563eb; border-radius: 8px; padding: 16px 18px; margin-bottom: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.04); }
.ai-summary-card.is-clean { background: #f0fdf4; border-color: #bbf7d0; border-left-color: #16a34a; }
.ai-summary-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; flex-wrap: wrap; gap: 8px; }
.ai-summary-title { display: flex; align-items: center; gap: 8px; font-size: 0.82rem; font-weight: 700; color: #1e40af; text-transform: uppercase; letter-spacing: 0.04em; }
.ai-summary-card.is-clean .ai-summary-title { color: #15803d; }
.ai-summary-badge { background: #dbeafe; color: #1d4ed8; font-size: 0.72rem; padding: 2px 8px; border-radius: 12px; font-weight: 600; border: 1px solid #bfdbfe; }
.ai-summary-card.is-clean .ai-summary-badge { background: #dcfce7; color: #15803d; border-color: #bbf7d0; }
.ai-summary-body { font-size: 0.88rem; line-height: 1.6; color: #1e293b; }
.ai-summary-body p { margin: 0 0 8px 0; }
.ai-summary-body p:last-child { margin-bottom: 0; }
.ai-citation { display: inline-block; background: #e0e7ff; color: #3730a3; font-family: monospace; font-size: 0.75rem; font-weight: 700; padding: 1px 5px; border-radius: 4px; margin: 0 2px; border: 1px solid #c7d2fe; }
.ai-summary-card.is-clean .ai-citation { background: #dcfce7; color: #166534; border-color: #bbf7d0; }
.ai-summary-footer { margin-top: 12px; padding-top: 10px; border-top: 1px dashed #cbd5e1; display: flex; justify-content: space-between; align-items: center; font-size: 0.76rem; color: #64748b; flex-wrap: wrap; gap: 8px; }
.ai-btn-copy { background: white; border: 1px solid #cbd5e1; border-radius: 5px; padding: 4px 10px; font-size: 0.76rem; font-weight: 600; cursor: pointer; color: #334155; transition: all 0.15s; }
.ai-btn-copy:hover { background: #f1f5f9; color: #0f172a; }
.ai-guardrail-tag { display: flex; align-items: center; gap: 5px; color: #475569; }
.ai-rag-details { margin-top: 10px; padding: 10px 12px; background: white; border: 1px solid #e2e8f0; border-radius: 6px; font-size: 0.78rem; font-family: monospace; color: #334155; white-space: pre-wrap; display: none; line-height: 1.45; }


/* 4-Bar Signal Meter */
.signal-gauge-wrap { display: flex; flex-direction: column; gap: 4px; min-width: 120px; cursor: default; }
.signal-gauge { display: flex; gap: 3px; align-items: center; width: 68px; }
.gauge-bar { flex: 1; height: 6px; border-radius: 2px; background: #e2e8f0; }

.signal-gauge.level-4 .gauge-bar { background: #ef4444; }
.gauge-meta.level-4 .gauge-label { color: #dc2626; font-weight: 700; }

.signal-gauge.level-3 .gauge-bar:nth-child(-n+3) { background: #f59e0b; }
.gauge-meta.level-3 .gauge-label { color: #d97706; font-weight: 700; }

.signal-gauge.level-2 .gauge-bar:nth-child(-n+2) { background: #eab308; }
.gauge-meta.level-2 .gauge-label { color: #ca8a04; font-weight: 600; }

.signal-gauge.level-1 .gauge-bar:nth-child(1) { background: #3b82f6; }
.gauge-meta.level-1 .gauge-label { color: #2563eb; font-weight: 600; }

.signal-gauge.level-0 .gauge-bar { background: #e2e8f0; }
.gauge-meta.level-0 .gauge-label { color: #64748b; font-weight: 500; }

.gauge-meta { display: flex; align-items: center; gap: 6px; font-size: 0.76rem; }
.gauge-label { font-size: 0.78rem; text-transform: uppercase; letter-spacing: 0.03em; }
.gauge-score { font-size: 0.72rem; color: #64748b; }

.drawer-gauge { display: flex; gap: 6px; width: 140px; margin: 8px 0; }
.drawer-gauge .gauge-bar { height: 10px; border-radius: 3px; background: #e2e8f0; flex: 1; }
.drawer-gauge.level-4 .gauge-bar { background: #ef4444; }
.drawer-gauge.level-3 .gauge-bar:nth-child(-n+3) { background: #f59e0b; }
.drawer-gauge.level-2 .gauge-bar:nth-child(-n+2) { background: #eab308; }
.drawer-gauge.level-1 .gauge-bar:nth-child(1) { background: #3b82f6; }
.drawer-gauge.level-0 .gauge-bar { background: #e2e8f0; }

/* Friction Bar */
.ratio-wrap { display: flex; align-items: center; gap: 8px; min-width: 110px; }
.ratio-bar-bg { flex: 1; height: 6px; background: #e2e8f0; border-radius: 3px; overflow: hidden; }
.ratio-bar-fill { height: 100%; border-radius: 3px; }
.ratio-bar-fill.fill-high { background: #ef4444; }
.ratio-bar-fill.fill-mid { background: #f59e0b; }
.ratio-bar-fill.fill-low { background: #10b981; }
.ratio-txt { font-size: 0.76rem; font-weight: 600; color: var(--text-muted); min-width: 32px; }

/* Table Footer / Pagination */
.table-footer { display: flex; justify-content: space-between; align-items: center; margin-top: 14px; font-size: 0.82rem; color: var(--text-muted); flex-wrap: wrap; gap: 10px; }
.pagination { display: flex; gap: 4px; align-items: center; }
.pagination button { padding: 5px 11px; font-size: 0.8rem; margin: 0; background: white; color: var(--text-main); border: 1px solid var(--border); border-radius: 4px; cursor: pointer; }
.pagination button:hover:not(:disabled) { background: #eef3f9; }
.pagination button:disabled { opacity: 0.45; cursor: default; }

/* Action buttons */
.btn-action { background: var(--primary); color: white; padding: 6px 12px; border: none; border-radius: 6px; font-size: 0.82rem; font-weight: 500; cursor: pointer; transition: background 0.15s; }
.btn-action:hover { background: var(--primary-hover); }

/* Slide-Over Drawer - 70% Executive Width */
.drawer-backdrop { position: fixed; inset: 0; background: rgba(17, 30, 56, 0.45); backdrop-filter: blur(2px); z-index: 1000; display: flex; justify-content: flex-end; animation: fadeIn 0.15s ease-out; }
.drawer { width: 70vw; min-width: 680px; max-width: 90vw; height: 100%; background: white; box-shadow: -6px 0 32px rgba(17, 30, 56, 0.28); display: flex; flex-direction: column; animation: slideIn 0.2s ease-out; }
@media (max-width: 900px) { .drawer { width: 95vw; min-width: 0; } }
.drawer-header { padding: 20px 24px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: flex-start; background: #f8fafc; }
.drawer-title h2 { margin: 0; font-size: 1.25rem; color: var(--text-main); }
.drawer-title p { margin: 4px 0 0 0; color: var(--text-muted); font-size: 0.84rem; }

/* Executive Takeaways & Scorecards */
.exec-takeaways { display: flex; flex-direction: column; gap: 10px; margin: 12px 0 8px 0; }
.takeaway-card { background: white; border: 1px solid #e2e8f0; border-radius: 8px; padding: 12px 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.03); }
.takeaway-card.alert { border-left: 4px solid #ef4444; }
.takeaway-card.defect { border-left: 4px solid #2563eb; }
.takeaway-card.risk { border-left: 4px solid #f59e0b; }
.takeaway-card.clean { border-left: 4px solid #10b981; }
.takeaway-header { margin-bottom: 6px; }
.takeaway-badge { font-weight: 700; font-size: 0.78rem; text-transform: uppercase; letter-spacing: 0.04em; color: #475569; display: flex; align-items: center; gap: 6px; }
.takeaway-card.alert .takeaway-badge { color: #b91c1c; }
.takeaway-card.defect .takeaway-badge { color: #1d4ed8; }
.takeaway-card.risk .takeaway-badge { color: #b45309; }
.takeaway-card.clean .takeaway-badge { color: #15803d; }
.takeaway-body { font-size: 0.88rem; line-height: 1.55; color: #1e293b; }

/* Simplified Advisory Review Banner (Quiet & Noise-Free) */
.advisory-review-card { background: #faf5ff; border: 1px solid #e9d5ff; border-left: 4px solid #9333ea; border-radius: 8px; padding: 12px 16px; margin-bottom: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.03); }
.advisory-review-card.level-4 { border-left-color: #ef4444; background: #fff5f5; border-color: #fed7d7; }
.advisory-review-card.level-3 { border-left-color: #f59e0b; background: #fffbeb; border-color: #fde68a; }
.advisory-review-card.level-2 { border-left-color: #3b82f6; background: #eff6ff; border-color: #bfdbfe; }
.advisory-review-card.level-1 { border-left-color: #10b981; background: #f0fdf4; border-color: #bbf7d0; }
.advisory-card-header { display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 8px; margin-bottom: 4px; }
.advisory-card-title { font-size: 0.82rem; font-weight: 700; color: #6b21a8; text-transform: uppercase; letter-spacing: 0.03em; display: flex; align-items: center; gap: 6px; }
.advisory-review-card.level-4 .advisory-card-title { color: #991b1b; }
.advisory-review-card.level-3 .advisory-card-title { color: #92400e; }
.advisory-review-card.level-2 .advisory-card-title { color: #1e40af; }
.advisory-review-card.level-1 .advisory-card-title { color: #166534; }
.advisory-priority-pill { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 14px; font-size: 0.82rem; font-weight: 700; }
.advisory-priority-pill.level-4 { background: #fee2e2; color: #b91c1c; border: 1px solid #fca5a5; }
.advisory-priority-pill.level-3 { background: #fef3c7; color: #b45309; border: 1px solid #fcd34d; }
.advisory-priority-pill.level-2 { background: #dbeafe; color: #1d4ed8; border: 1px solid #93c5fd; }
.advisory-priority-pill.level-1 { background: #dcfce7; color: #15803d; border: 1px solid #86efac; }
.priority-dot { width: 8px; height: 8px; border-radius: 50%; background: currentColor; }
.advisory-card-sub { font-size: 0.78rem; color: #64748b; line-height: 1.4; }

/* Executive What-If Decision Cards */
.exec-scenario-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 14px; margin-bottom: 16px; }
.exec-scenario-card { background: white; border: 1px solid var(--border); border-radius: 8px; padding: 16px; display: flex; flex-direction: column; justify-content: space-between; transition: all 0.15s; box-shadow: 0 1px 3px rgba(0,0,0,0.04); }
.exec-scenario-card:hover { border-color: #3b82f6; box-shadow: 0 4px 12px rgba(59, 130, 246, 0.1); }
.exec-scenario-card.card-recommended { border-top: 4px solid #10b981; background: #f0fdf4; border-color: #bbf7d0; }
.exec-scenario-card.card-least-priv { border-top: 4px solid #3b82f6; background: #eff6ff; border-color: #bfdbfe; }
.exec-scenario-title { font-weight: 700; font-size: 0.95rem; color: #0f172a; display: flex; align-items: center; gap: 8px; margin-bottom: 6px; }
.exec-scenario-desc { font-size: 0.82rem; color: #475569; margin-bottom: 12px; line-height: 1.45; }
.exec-scenario-btn { width: 100%; padding: 8px 14px; border: none; border-radius: 6px; font-weight: 600; font-size: 0.84rem; cursor: pointer; transition: background 0.15s; }
.btn-sim-recommended { background: #16a34a; color: white; }
.btn-sim-recommended:hover { background: #15803d; }
.btn-sim-least { background: #2563eb; color: white; }
.btn-sim-least:hover { background: #1d4ed8; }

.exec-delta-banner { background: #f8fafc; border: 1px solid #cbd5e1; border-radius: 8px; padding: 14px 18px; margin-bottom: 14px; display: flex; justify-content: space-around; flex-wrap: wrap; gap: 12px; text-align: center; }
.exec-delta-metric { display: flex; flex-direction: column; align-items: center; }
.exec-delta-lbl { font-size: 0.72rem; font-weight: 700; text-transform: uppercase; color: #64748b; letter-spacing: 0.04em; }
.exec-delta-val { font-size: 1.35rem; font-weight: 800; color: #0f172a; margin-top: 2px; }
.exec-delta-val.val-good { color: #16a34a; }
.exec-delta-val.val-warn { color: #d97706; }

.drawer-body { padding: 24px; overflow-y: auto; flex: 1; }
.btn-close { background: white; border: 1px solid var(--border); border-radius: 6px; padding: 6px 14px; font-size: 0.85rem; font-weight: 600; cursor: pointer; color: var(--text-muted); }
.btn-close:hover { background: #e2e8f0; color: var(--text-main); }

@keyframes slideIn { from { transform: translateX(100%); } to { transform: translateX(0); } }
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

/* Form inputs & reviews */
textarea { display: block; width: 100%; min-height: 90px; padding: 10px; border: 1px solid var(--border); border-radius: 6px; font: inherit; margin: 8px 0; }
select { padding: 8px 12px; border: 1px solid var(--border); border-radius: 6px; font: inherit; }

/* Drawer Tab Navigation */
.drawer-tabs { display: flex; gap: 4px; padding: 0 24px; background: #f8fafc; border-bottom: 1px solid var(--border); }
.drawer-tab { padding: 10px 16px; border: none; background: transparent; font-size: 0.86rem; font-weight: 600; color: var(--text-muted); cursor: pointer; border-bottom: 3px solid transparent; transition: all 0.15s; }
.drawer-tab:hover { color: var(--primary); }
.drawer-tab.active-tab { color: var(--primary); border-bottom-color: var(--primary); background: white; }

/* Simulation Studio */
.sim-studio { display: flex; flex-direction: column; gap: 16px; }
.sim-preset-card { background: #f0f7ff; border: 1px solid #c7e0f9; border-radius: 8px; padding: 14px 16px; }
.sim-preset-card h4 { margin: 0 0 8px 0; font-size: 0.78rem; color: #0369a1; text-transform: uppercase; letter-spacing: 0.04em; }
.sim-preset-row { display: flex; gap: 8px; flex-wrap: wrap; }
.sim-preset-btn { font-size: 0.82rem; padding: 7px 12px; border-radius: 6px; border: 1px solid #bae0fd; background: white; color: #0284c7; cursor: pointer; font-weight: 600; transition: all 0.15s; display: flex; align-items: center; gap: 6px; }
.sim-preset-btn:hover { background: #0284c7; color: white; border-color: #0284c7; }

/* Simulation Config Form */
.sim-form-card { background: #fbfcfe; border: 1px solid var(--border); border-radius: 8px; padding: 16px; }
.sim-form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 12px; margin-bottom: 14px; }
.sim-field label { display: block; font-size: 0.75rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; margin-bottom: 5px; }
.sim-field select, .sim-field input { width: 100%; padding: 7px 10px; font-size: 0.85rem; border: 1px solid var(--border); border-radius: 6px; background: white; box-sizing: border-box; }
.btn-run-sim { background: #7c3aed; color: white; border: none; padding: 8px 18px; border-radius: 6px; font-weight: 600; font-size: 0.86rem; cursor: pointer; transition: background 0.15s; display: inline-flex; align-items: center; gap: 6px; }
.btn-run-sim:hover:not(:disabled) { background: #6d28d9; }
.btn-run-sim:disabled { opacity: 0.5; }

/* Simulation KPI Grid */
.sim-kpi-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(170px, 1fr)); gap: 12px; }
.sim-kpi { background: white; border: 1px solid var(--border); border-radius: 8px; padding: 14px 16px; border-top: 4px solid var(--primary); }
.sim-kpi.sim-kpi-alert { border-top-color: #ef4444; }
.sim-kpi.sim-kpi-warn { border-top-color: #f59e0b; }
.sim-kpi.sim-kpi-success { border-top-color: #10b981; }
.sim-kpi-label { font-size: 0.72rem; font-weight: 700; text-transform: uppercase; color: var(--text-muted); letter-spacing: 0.04em; }
.sim-kpi-val { font-size: 1.55rem; font-weight: 800; color: var(--text-main); margin: 4px 0 2px 0; }
.sim-kpi-sub { font-size: 0.76rem; color: var(--text-muted); }

/* Policy Notice Banner */
.policy-banner { padding: 12px 16px; border-radius: 8px; font-size: 0.84rem; display: flex; align-items: center; gap: 10px; font-weight: 500; }
.policy-banner.banner-info { background: #ecfdf5; border: 1px solid #a7f3d0; color: #065f46; }
.policy-banner.banner-warn { background: #fffbeb; border: 1px solid #fde68a; color: #92400e; }

/* ServiceNow Catalog: Business Role Modification Request Modal */
.sn-modal-overlay { position: fixed; inset: 0; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px); z-index: 2000; display: flex; align-items: center; justify-content: center; padding: 20px; animation: fadeIn 0.15s ease-out; }
.sn-modal { background: #ffffff; border-radius: 12px; width: 680px; max-width: 95vw; max-height: 90vh; overflow-y: auto; box-shadow: 0 20px 50px rgba(0, 0, 0, 0.25); border: 1px solid #cbd5e1; display: flex; flex-direction: column; }
.sn-modal-header { padding: 18px 24px; background: #0f172a; color: white; display: flex; justify-content: space-between; align-items: center; border-radius: 12px 12px 0 0; }
.sn-header-left { display: flex; align-items: center; gap: 12px; }
.sn-logo-badge { background: #16a34a; color: white; font-size: 0.75rem; font-weight: 800; padding: 3px 8px; border-radius: 4px; letter-spacing: 0.05em; text-transform: uppercase; }
.sn-header-titles h3 { margin: 0; font-size: 1.12rem; font-weight: 700; color: #ffffff; }
.sn-header-titles p { margin: 2px 0 0 0; font-size: 0.78rem; color: #94a3b8; }
.sn-close-btn { background: rgba(255,255,255,0.1); border: none; color: #cbd5e1; width: 30px; height: 30px; border-radius: 50%; cursor: pointer; font-size: 1rem; display: flex; align-items: center; justify-content: center; transition: all 0.15s; }
.sn-close-btn:hover { background: rgba(255,255,255,0.25); color: white; }
.sn-modal-body { padding: 22px 24px; display: flex; flex-direction: column; gap: 16px; font-size: 0.88rem; }
.sn-role-context { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 12px 16px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px; }
.sn-role-title { font-weight: 800; font-size: 1rem; color: #0f172a; }
.sn-role-meta { font-size: 0.8rem; color: #64748b; margin-top: 2px; }
.sn-target-badge { font-size: 0.76rem; font-weight: 700; color: #1e40af; background: #dbeafe; padding: 4px 10px; border-radius: 12px; border: 1px solid #bfdbfe; }
.sn-form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.sn-field-label { display: block; font-size: 0.76rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; color: #475569; margin-bottom: 6px; }
.sn-select, .sn-textarea { width: 100%; border: 1px solid #cbd5e1; border-radius: 6px; padding: 8px 12px; font-size: 0.86rem; box-sizing: border-box; background: white; }
.sn-apps-card { background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 8px; padding: 12px 14px; }
.sn-apps-title { font-size: 0.76rem; font-weight: 700; color: #166534; text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 6px; display: flex; align-items: center; gap: 6px; }
.sn-apps-list { display: flex; flex-wrap: wrap; gap: 6px; }
.sn-app-pill { background: white; border: 1px solid #86efac; color: #15803d; font-size: 0.78rem; font-weight: 600; padding: 3px 9px; border-radius: 12px; display: inline-flex; align-items: center; gap: 4px; box-shadow: 0 1px 2px rgba(0,0,0,0.03); }
.sn-dossier-box { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 14px 16px; }
.sn-dossier-title { font-size: 0.78rem; font-weight: 700; color: #334155; text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center; }
.sn-dossier-pillars { display: flex; flex-direction: column; gap: 8px; font-size: 0.84rem; }
.sn-pillar-item { display: flex; align-items: baseline; gap: 8px; }
.sn-pillar-num { flex-shrink: 0; width: 18px; height: 18px; border-radius: 50%; background: #2563eb; color: white; font-size: 0.7rem; font-weight: 800; display: inline-flex; align-items: center; justify-content: center; }
.sn-pillar-text strong { color: #0f172a; }
.sn-modal-footer { padding: 16px 24px; background: #f8fafc; border-top: 1px solid #e2e8f0; display: flex; justify-content: flex-end; align-items: center; gap: 12px; border-radius: 0 0 12px 12px; }
.sn-btn-cancel { background: white; border: 1px solid #cbd5e1; padding: 9px 18px; border-radius: 6px; font-weight: 600; font-size: 0.86rem; color: #475569; cursor: pointer; }
.sn-btn-cancel:hover { background: #f1f5f9; color: #0f172a; }
.sn-btn-submit { background: #16a34a; border: none; padding: 10px 22px; border-radius: 6px; font-weight: 700; font-size: 0.9rem; color: white; cursor: pointer; box-shadow: 0 2px 6px rgba(22, 163, 74, 0.3); transition: all 0.15s; display: inline-flex; align-items: center; gap: 8px; }
.sn-btn-submit:hover:not(:disabled) { background: #15803d; }
.sn-btn-submit:disabled { opacity: 0.55; cursor: default; }

/* 5 Pillars of Evidence Layout (Noise-Reduced & Spaced) */
.pillars-container, .pillars-grid { display: flex; flex-direction: column; gap: 16px; margin: 18px 0; }
.pillar-card { background: white; border: 1px solid #e2e8f0; border-radius: 10px; padding: 16px 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.04); transition: transform 0.15s, box-shadow 0.15s; }
.pillar-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
.pillar-card.pillar-defect { border-left: 5px solid #2563eb; background: #f8faff; }
.pillar-card.pillar-apps { border-left: 5px solid #059669; background: #f6fdf9; }
.pillar-card.pillar-tickets { border-left: 5px solid #e11d48; background: #fff8f8; }
.pillar-card.pillar-peers { border-left: 5px solid #7c3aed; background: #faf8ff; }
.pillar-card.pillar-movers { border-left: 5px solid #d97706; background: #fffcf4; }
.pillar-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px; flex-wrap: wrap; gap: 8px; }
.pillar-badge { font-weight: 800; font-size: 0.84rem; text-transform: uppercase; letter-spacing: 0.04em; display: flex; align-items: center; gap: 8px; }
.pillar-tag { font-size: 0.76rem; font-weight: 700; padding: 3px 10px; border-radius: 12px; }
.pillar-defect .pillar-badge { color: #1d4ed8; }
.pillar-defect .pillar-tag { background: #dbeafe; color: #1e40af; }
.pillar-apps .pillar-badge { color: #047857; }
.pillar-apps .pillar-tag { background: #d1fae5; color: #065f46; }
.pillar-tickets .pillar-badge { color: #be123c; }
.pillar-tickets .pillar-tag { background: #ffe4e6; color: #9f1239; }
.pillar-peers .pillar-badge { color: #6d28d9; }
.pillar-peers .pillar-tag { background: #ede9fe; color: #5b21b6; }
.pillar-movers .pillar-badge { color: #b45309; }
.pillar-movers .pillar-tag { background: #fef3c7; color: #92400e; }
.pillar-body { font-size: 0.9rem; line-height: 1.6; color: #334155; }

/* Remediation In Progress Banner & Badges */
.remediation-active-banner { background: #f0fdf4; border: 1px solid #86efac; border-left: 5px solid #16a34a; border-radius: 8px; padding: 12px 16px; margin-bottom: 16px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px; }
.remediation-badge { background: #dcfce7; color: #15803d; border: 1px solid #86efac; font-weight: 700; font-size: 0.76rem; padding: 3px 8px; border-radius: 12px; display: inline-flex; align-items: center; gap: 4px; }
.remediation-active-title { font-size: 0.92rem; font-weight: 800; color: #14532d; display: flex; align-items: center; gap: 6px; }
.remediation-active-desc { font-size: 0.82rem; color: #166534; margin-top: 2px; }

/* Role Differentiator (Intuitive Multi-Insight View) */
.rd-wrap { max-width: 960px; margin: 0 auto; display: flex; flex-direction: column; gap: 16px; }
.rd-pickers { display: grid; grid-template-columns: 1fr auto 1fr; gap: 14px; align-items: end; background: white; padding: 16px 20px; border-radius: 12px; border: 1px solid #e2e8f0; box-shadow: 0 1px 3px rgba(0,0,0,0.03); }
@media (max-width: 768px) { .rd-pickers { grid-template-columns: 1fr; } }
.rd-pick label { display: block; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: #475569; margin-bottom: 6px; }
.rd-pick select { width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 0.92rem; font-weight: 600; color: #0f172a; background: #fff; cursor: pointer; }
.rd-pick select:focus { border-color: #2563eb; outline: none; }
.rd-swap { width: 40px; height: 40px; border-radius: 50%; border: 1px solid #cbd5e1; background: #f8fafc; color: #334155; cursor: pointer; font-size: 1.15rem; display: flex; align-items: center; justify-content: center; transition: all 0.15s; }
.rd-swap:hover { background: #e2e8f0; color: #0f172a; }
.rd-presets { display: flex; gap: 8px; flex-wrap: wrap; }
.rd-chip { background: white; border: 1px solid #cbd5e1; border-radius: 16px; padding: 5px 12px; font-size: 0.78rem; font-weight: 600; color: #334155; cursor: pointer; transition: all 0.15s; }
.rd-chip:hover { background: #f1f5f9; color: #0f172a; border-color: #94a3b8; }
.rd-headline { display: flex; align-items: center; gap: 16px; flex-wrap: wrap; padding: 18px 22px; border-radius: 12px; border: 1px solid #e2e8f0; background: #f8fafc; }
.rd-headline.bad { background: #fff7f7; border-color: #fecaca; }
.rd-headline.warn { background: #fffbeb; border-color: #fde68a; }
.rd-headline.ok { background: #f0fdf4; border-color: #bbf7d0; }
.rd-title { font-size: 1.12rem; font-weight: 700; color: #0f172a; line-height: 1.4; flex: 1; min-width: 280px; }
.rd-stats { display: flex; gap: 8px; flex-wrap: wrap; }
.rd-stat { font-family: ui-monospace, Consolas, monospace; font-weight: 800; font-size: 0.88rem; padding: 4px 10px; border-radius: 6px; }
.rd-stat.add { background: #dcfce7; color: #166534; }
.rd-stat.del { background: #fee2e2; color: #991b1b; }
.rd-stat.same { background: #f1f5f9; color: #475569; font-weight: 600; }
.rd-impact { width: 100%; font-size: 0.84rem; color: #475569; line-height: 1.4; padding-top: 4px; border-top: 1px dashed rgba(0,0,0,0.1); }

/* Insight Sub-Tabs */
.rd-tabs { display: flex; gap: 8px; border-bottom: 2px solid #e2e8f0; padding-bottom: 8px; margin: 4px 0 10px 0; flex-wrap: wrap; }
.rd-tab-btn { background: #f1f5f9; border: 1px solid #cbd5e1; color: #475569; padding: 7px 16px; border-radius: 20px; font-weight: 700; font-size: 0.84rem; cursor: pointer; transition: all 0.15s; }
.rd-tab-btn:hover { background: #e2e8f0; color: #0f172a; }
.rd-tab-btn.active { background: #0f172a; color: #fff; border-color: #0f172a; box-shadow: 0 2px 6px rgba(15,23,42,0.25); }

/* Unified Discrepancy Card Layout */
.rd-cards-container { display: flex; flex-direction: column; gap: 10px; }
.rd-item-card { background: white; border: 1px solid #e2e8f0; border-radius: 8px; padding: 12px 18px; display: flex; align-items: center; justify-content: space-between; gap: 14px; flex-wrap: wrap; transition: all 0.15s; }
.rd-item-card:hover { border-color: #cbd5e1; box-shadow: 0 2px 6px rgba(0,0,0,0.03); }
.rd-item-card.add { border-left: 5px solid #16a34a; background: #fafffb; }
.rd-item-card.del { border-left: 5px solid #ef4444; background: #fffafa; }
.rd-item-card.same { border-left: 5px solid #94a3b8; background: #f8fafc; }
.rd-item-main { display: flex; flex-direction: column; gap: 4px; min-width: 280px; flex: 1; }
.rd-item-title { font-weight: 700; font-size: 0.94rem; color: #0f172a; display: flex; align-items: center; gap: 8px; }
.rd-item-pills { display: flex; gap: 6px; flex-wrap: wrap; align-items: center; margin-top: 2px; }
.rd-pill { font-size: 0.74rem; font-weight: 600; padding: 2px 8px; border-radius: 6px; display: inline-flex; align-items: center; gap: 4px; }
.rd-pill-app { background: #e0f2fe; color: #0369a1; border: 1px solid #bae6fd; }
.rd-pill-group { background: #ede9fe; color: #5b21b6; border: 1px solid #ddd6fe; font-family: ui-monospace, Consolas, monospace; }
.rd-pill-risk { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
.rd-pill-risk.standard { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
.rd-pill-cat { background: #f1f5f9; color: #475569; }
.rd-req { background: #16a34a; color: #fff; border: none; border-radius: 6px; padding: 6px 14px; font-size: 0.8rem; font-weight: 700; cursor: pointer; transition: all 0.15s; box-shadow: 0 1px 3px rgba(22, 163, 74, 0.25); }
.rd-req:hover { background: #15803d; }
.rd-toggle { width: 100%; border: 1px dashed #cbd5e1; border-radius: 8px; background: #f8fafc; color: #475569; padding: 10px; font-size: 0.82rem; font-weight: 600; cursor: pointer; text-align: center; }
.rd-toggle:hover { background: #f1f5f9; color: #0f172a; }
.rd-empty { padding: 24px; text-align: center; color: #64748b; font-size: 0.9rem; background: #fff; border-radius: 8px; border: 1px dashed #cbd5e1; }

/* Application Access Grid */
.rd-app-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(290px, 1fr)); gap: 16px; }
.rd-app-box { background: white; border: 1px solid #e2e8f0; border-radius: 10px; padding: 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.03); }
.rd-app-box.add { border-top: 4px solid #16a34a; }
.rd-app-box.del { border-top: 4px solid #ef4444; }
.rd-app-box.same { border-top: 4px solid #64748b; }
.rd-app-name { font-weight: 700; font-size: 0.98rem; color: #0f172a; margin-bottom: 4px; display: flex; justify-content: space-between; align-items: center; }
.rd-app-cat { font-size: 0.78rem; color: #64748b; margin-bottom: 8px; }
.rd-app-ents { font-size: 0.84rem; color: #334155; line-height: 1.5; background: #f8fafc; padding: 8px 10px; border-radius: 6px; }

/* AD Security Groups Matrix */
.rd-group-card { background: white; border: 1px solid #e2e8f0; border-radius: 8px; padding: 12px 16px; margin-bottom: 10px; display: flex; align-items: center; justify-content: space-between; gap: 14px; flex-wrap: wrap; }
.rd-group-card.add { border-left: 5px solid #16a34a; }
.rd-group-card.del { border-left: 5px solid #ef4444; }
.rd-group-name { font-family: ui-monospace, Consolas, monospace; font-weight: 700; color: #4338ca; background: #ede9fe; padding: 3px 8px; border-radius: 6px; font-size: 0.88rem; }
.rd-group-meta { font-size: 0.82rem; color: #475569; margin-top: 4px; }

/* Success Card */
.sn-success-card { background: #f0fdf4; border: 1px solid #86efac; border-radius: 10px; padding: 24px; text-align: center; display: flex; flex-direction: column; align-items: center; gap: 12px; }
.sn-success-icon { width: 52px; height: 52px; border-radius: 50%; background: #16a34a; color: white; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; box-shadow: 0 4px 12px rgba(22, 163, 74, 0.3); }
.sn-ticket-box { background: white; border: 1px solid #bbf7d0; border-radius: 8px; padding: 14px 18px; width: 100%; box-sizing: border-box; text-align: left; display: grid; grid-template-columns: 1fr 1fr; gap: 10px; font-size: 0.82rem; }
.sn-ticket-field strong { display: block; font-size: 0.72rem; color: #64748b; text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 2px; }
.sn-ticket-field span { font-weight: 700; font-size: 0.9rem; color: #0f172a; }


'@

$html=@"
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Role Patrol | Evidence-Led Role Governance</title>
  <style>$css</style>
</head>
<body>
  <header>
    <div class="header-brand">
      <h1><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#38bdf8" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle;margin-right:8px"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>Role Patrol</h1>
      <small>Enterprise Role Governance &middot; Continuous Entitlement & Access Intelligence</small>
    </div>
    <div class="header-auth">
      <span id="identity"></span>
      <button id="signin">Sign in</button>
      <button id="signout" style="display:none;">Sign out</button>
    </div>
  </header>
  <main>
    <p id="message" role="status" aria-live="polite"></p>
    <section id="content"></section>
    <section id="review" style="display:none;"></section>
    <div id="drawerContainer"></div>
  </main>
  <script>window.RP_CONFIG=$cfg;</script>
  <script>$app</script>
  <script>$ticketSearch</script>
</body>
</html>
"@

$bridgeHtml="<!doctype html><html lang=`"en`"><head><meta charset=`"utf-8`"><title>Role Patrol sign-in return</title></head><body><p>Completing sign-in...</p><script>$bridge</script></body></html>"
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'dist/index.html'),$html,[Text.UTF8Encoding]::new($false))
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'dist/bridge.html'),$bridgeHtml,[Text.UTF8Encoding]::new($false))
$swaConfig = '{"navigationFallback":{"rewrite":"/index.html"},"globalHeaders":{"Cache-Control":"no-store","Referrer-Policy":"no-referrer","X-Content-Type-Options":"nosniff","X-Frame-Options":"DENY"}}'
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'dist/staticwebapp.config.json'),$swaConfig,[Text.UTF8Encoding]::new($false))
Get-Item (Join-Path $PSScriptRoot 'dist/index.html'),(Join-Path $PSScriptRoot 'dist/bridge.html'),(Join-Path $PSScriptRoot 'dist/staticwebapp.config.json')|Select-Object Name,Length
