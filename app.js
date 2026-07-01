const STORAGE_KEY = "dcg_reports_v3";
const USER_KEY = "dcg_responder_v1";

const categories = [
  { name: "Medical", icon: "+", color: "#dbe78f" },
  { name: "Violence", icon: "!", color: "#f5a6df" },
  { name: "Rescue", icon: "R", color: "#f5e8a6" },
  { name: "Fire", icon: "F", color: "#f5a6a6" },
  { name: "Natural disaster", icon: "N", color: "#a6f5d4" },
  { name: "Accident", icon: "A", color: "#d4cef9" }
];

const contacts = [
  { name: "Proctor Office", detail: "Campus discipline and response", phone: "+8801713493050" },
  { name: "Medical Center", detail: "First aid and ambulance support", phone: "+8801847334655" },
  { name: "Security Control", detail: "Gate, building, and night patrol", phone: "+8801912400700" },
  { name: "Transport Desk", detail: "Campus transport and route help", phone: "+8801811110001" }
];

const seedReports = [
  {
    id: "seed-1",
    name: "Proctor Office",
    contact: "+8801713493050",
    role: "Safety team",
    category: "Violence",
    location: "Main Campus Gate",
    priority: "High",
    status: "triage",
    details: "Crowd pressure reported near the gate. Safety team is monitoring.",
    createdAt: new Date(Date.now() - 8 * 60 * 1000).toISOString()
  },
  {
    id: "seed-2",
    name: "Transport Desk",
    contact: "+8801811110001",
    role: "Staff",
    category: "Accident",
    location: "Bus Stand",
    priority: "Medium",
    status: "open",
    details: "Minor transport incident reported. Route support requested.",
    createdAt: new Date(Date.now() - 24 * 60 * 1000).toISOString()
  },
  {
    id: "seed-3",
    name: "Medical Center",
    contact: "+8801847334655",
    role: "Staff",
    category: "Medical",
    location: "Knowledge Tower",
    priority: "Low",
    status: "resolved",
    details: "First-aid support completed on level 2.",
    createdAt: new Date(Date.now() - 53 * 60 * 1000).toISOString()
  }
];

const state = {
  reports: loadReports(),
  user: loadUser(),
  selectedCategory: "Medical",
  filters: {
    search: "",
    status: "all",
    priority: "all"
  },
  sosTimer: null,
  sosProgress: 0,
  firebaseReady: false,
  firebaseFns: null,
  auth: null,
  db: null
};

const els = {
  board: document.querySelector("#caseBoard"),
  categoryGrid: document.querySelector("#categoryGrid"),
  categorySelect: document.querySelector("#categorySelect"),
  caseList: document.querySelector("#caseList"),
  closeSosButton: document.querySelector("#closeSosButton"),
  clock: document.querySelector("#clock"),
  contactGrid: document.querySelector("#contactGrid"),
  criticalCases: document.querySelector("#criticalCases"),
  exportButton: document.querySelector("#exportButton"),
  firebaseStatus: document.querySelector("#firebaseStatus"),
  form: document.querySelector("#reportForm"),
  holdSosButton: document.querySelector("#holdSosButton"),
  openCases: document.querySelector("#openCases"),
  openSosButton: document.querySelector("#openSosButton"),
  priorityFilter: document.querySelector("#priorityFilter"),
  resolvedCases: document.querySelector("#resolvedCases"),
  searchInput: document.querySelector("#searchInput"),
  signInButton: document.querySelector("#signInButton"),
  sosModal: document.querySelector("#sosModal"),
  sosState: document.querySelector("#sosState"),
  statusFilter: document.querySelector("#statusFilter"),
  toast: document.querySelector("#toast"),
  userStatus: document.querySelector("#userStatus")
};

function loadReports() {
  try {
    const stored = JSON.parse(localStorage.getItem(STORAGE_KEY) || "null");
    return Array.isArray(stored) && stored.length ? stored : seedReports;
  } catch {
    return seedReports;
  }
}

function loadUser() {
  try {
    return JSON.parse(localStorage.getItem(USER_KEY) || "null");
  } catch {
    return null;
  }
}

function saveReports() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(state.reports));
}

function saveUser() {
  if (state.user) localStorage.setItem(USER_KEY, JSON.stringify(state.user));
  else localStorage.removeItem(USER_KEY);
}

function hasFirebaseConfig(config) {
  return config && Object.values(config).every((value) => value && !String(value).startsWith("PASTE_"));
}

async function initFirebase() {
  if (!hasFirebaseConfig(window.DCG_FIREBASE_CONFIG)) {
    setFirebaseStatus(false, "Local demo mode");
    return;
  }

  try {
    const [appModule, authModule, firestoreModule] = await Promise.all([
      import("https://www.gstatic.com/firebasejs/10.12.5/firebase-app.js"),
      import("https://www.gstatic.com/firebasejs/10.12.5/firebase-auth.js"),
      import("https://www.gstatic.com/firebasejs/10.12.5/firebase-firestore.js")
    ]);

    const app = appModule.initializeApp(window.DCG_FIREBASE_CONFIG);
    state.firebaseFns = { ...authModule, ...firestoreModule };
    state.auth = authModule.getAuth(app);
    state.db = firestoreModule.getFirestore(app);
    state.firebaseReady = true;
    setFirebaseStatus(true, "Firebase connected");
  } catch (error) {
    setFirebaseStatus(false, "Firebase config error");
    showToast(error.message);
  }
}

function setFirebaseStatus(connected, label) {
  els.firebaseStatus.textContent = label;
  els.firebaseStatus.classList.toggle("connected", connected);
}

function filteredReports() {
  const search = state.filters.search.toLowerCase().trim();

  return state.reports.filter((report) => {
    const statusOk = state.filters.status === "all" || report.status === state.filters.status;
    const priorityOk = state.filters.priority === "all" || report.priority.toLowerCase() === state.filters.priority;
    const text = [
      report.name,
      report.contact,
      report.role,
      report.category,
      report.location,
      report.priority,
      report.status,
      report.details
    ]
      .join(" ")
      .toLowerCase();

    return statusOk && priorityOk && (!search || text.includes(search));
  });
}

function renderCategories() {
  els.categorySelect.innerHTML = categories.map((category) => `<option>${category.name}</option>`).join("");
  els.categorySelect.value = state.selectedCategory;

  els.categoryGrid.innerHTML = categories
    .map(
      (category) => `
        <button class="category-card ${category.name === state.selectedCategory ? "selected" : ""}" type="button" data-category="${category.name}">
          <span class="category-icon" style="--category-bg:${category.color}">${category.icon}</span>
          <span>${category.name}</span>
        </button>
      `
    )
    .join("");
}

function renderMetrics() {
  els.openCases.textContent = String(state.reports.filter((report) => report.status !== "resolved").length);
  els.criticalCases.textContent = String(state.reports.filter((report) => report.priority === "Critical").length);
  els.resolvedCases.textContent = String(state.reports.filter((report) => report.status === "resolved").length);
}

function renderCases() {
  const reports = filteredReports();
  els.caseList.innerHTML = reports.length
    ? reports.map(renderCaseRow).join("")
    : `<div class="empty-state">No reports match the current filters.</div>`;

  renderMetrics();
  renderBoard();
}

function renderCaseRow(report) {
  return `
    <article class="case-row">
      <div>
        <h3>${escapeHtml(report.location)}</h3>
        <p>${escapeHtml(report.details)}</p>
        <div class="case-meta">
          <span class="tag">${escapeHtml(report.category)}</span>
          <span class="priority ${report.priority.toLowerCase()}">${escapeHtml(report.priority)}</span>
          <span class="status-label"><span class="status-dot ${report.status}"></span>${escapeHtml(report.status)}</span>
          <span class="tag">${escapeHtml(report.name)} - ${escapeHtml(relativeTime(report.createdAt))}</span>
        </div>
      </div>
      <div class="case-actions">
        <button class="quiet-button" type="button" data-copy="${escapeHtml(report.contact)}">Copy</button>
        <button class="quiet-button" type="button" data-status-id="${report.id}" data-next-status="triage">Triage</button>
        <button class="primary-button" type="button" data-status-id="${report.id}" data-next-status="resolved">Resolve</button>
      </div>
    </article>
  `;
}

function renderBoard() {
  const columns = [
    { key: "open", label: "Open" },
    { key: "triage", label: "Triage" },
    { key: "resolved", label: "Resolved" }
  ];

  els.board.innerHTML = columns
    .map((column) => {
      const reports = state.reports.filter((report) => report.status === column.key);
      return `
        <section class="board-column">
          <div class="board-head">
            <span>${column.label}</span>
            <span>${reports.length}</span>
          </div>
          ${
            reports.length
              ? reports.slice(0, 6).map(renderBoardCard).join("")
              : `<div class="empty-state">No ${column.label.toLowerCase()} cases</div>`
          }
        </section>
      `;
    })
    .join("");
}

function renderBoardCard(report) {
  return `
    <article class="board-card">
      <h3>${escapeHtml(report.location)}</h3>
      <p>${escapeHtml(report.category)} - ${escapeHtml(report.priority)}</p>
      <p>${escapeHtml(report.details)}</p>
    </article>
  `;
}

function renderContacts() {
  els.contactGrid.innerHTML = contacts
    .map(
      (contact) => `
        <article class="contact-card">
          <h3>${contact.name}</h3>
          <p>${contact.detail}</p>
          <div class="contact-actions">
            <a class="quiet-button" href="tel:${contact.phone}">Call</a>
            <button class="quiet-button" type="button" data-copy="${contact.phone}">Copy</button>
          </div>
        </article>
      `
    )
    .join("");
}

function updateUserUi() {
  els.userStatus.textContent = state.user ? `${state.user.name} active` : "Guest responder";
  els.signInButton.textContent = state.user ? "Sign out" : "Responder sign in";
}

function submitReport(event) {
  event.preventDefault();
  const form = new FormData(event.currentTarget);
  const report = normalizeReport({
    id: crypto.randomUUID(),
    name: form.get("name"),
    contact: form.get("contact"),
    role: form.get("role"),
    category: form.get("category"),
    location: form.get("location"),
    priority: form.get("priority"),
    details: form.get("details"),
    status: "open",
    createdAt: new Date().toISOString()
  });

  state.reports.unshift(report);
  saveReports();
  renderCases();
  event.currentTarget.reset();
  els.categorySelect.value = state.selectedCategory;
  showToast("Report submitted.");
}

function normalizeReport(report) {
  return {
    id: String(report.id || crypto.randomUUID()),
    name: String(report.name || "Anonymous").trim(),
    contact: String(report.contact || "").trim(),
    role: String(report.role || "Reporter").trim(),
    category: String(report.category || "Medical").trim(),
    location: String(report.location || "Campus").trim(),
    priority: String(report.priority || "Medium").trim(),
    status: String(report.status || "open").trim(),
    details: String(report.details || "No details provided.").trim(),
    createdAt: report.createdAt || new Date().toISOString(),
    updatedAt: report.updatedAt || "",
    updatedBy: report.updatedBy || ""
  };
}

function updateStatus(id, status) {
  const report = state.reports.find((item) => item.id === id);
  if (!report) return;
  report.status = status;
  report.updatedAt = new Date().toISOString();
  report.updatedBy = state.user?.name || "Guest responder";
  saveReports();
  renderCases();
  showToast(`Marked as ${status}.`);
}

function openSosModal() {
  els.sosModal.classList.add("show");
  els.sosModal.setAttribute("aria-hidden", "false");
}

function closeSosModal() {
  els.sosModal.classList.remove("show");
  els.sosModal.setAttribute("aria-hidden", "true");
}

function beginSosHold() {
  if (state.sosTimer) return;
  state.sosProgress = 3;
  els.holdSosButton.classList.add("holding");
  els.sosState.classList.add("calling");
  els.sosState.innerHTML = `<strong>Calling Emergency...</strong><span>Hold for ${state.sosProgress} seconds</span>`;

  state.sosTimer = window.setInterval(() => {
    state.sosProgress -= 1;
    if (state.sosProgress > 0) {
      els.sosState.innerHTML = `<strong>Calling Emergency...</strong><span>Hold for ${state.sosProgress} seconds</span>`;
      return;
    }
    finishSosHold();
  }, 1000);
}

function cancelSosHold() {
  if (!state.sosTimer) return;
  window.clearInterval(state.sosTimer);
  state.sosTimer = null;
  state.sosProgress = 0;
  els.holdSosButton.classList.remove("holding");
  els.sosState.classList.remove("calling");
  els.sosState.innerHTML = `<strong>Ready</strong><span>Live location sharing is simulated for the campus response flow.</span>`;
}

function finishSosHold() {
  window.clearInterval(state.sosTimer);
  state.sosTimer = null;
  els.holdSosButton.classList.remove("holding");
  createSosCase("Current campus location");
  openSosModal();
}

function createSosCase(location) {
  const report = normalizeReport({
    id: crypto.randomUUID(),
    name: state.user?.name || "Emergency trigger",
    contact: "+8801713493050",
    role: "Responder",
    category: state.selectedCategory || "Medical",
    location,
    priority: "Critical",
    status: "open",
    details: `SOS triggered for ${location}. Live location shared with nearest help centre and emergency contacts.`,
    createdAt: new Date().toISOString()
  });
  state.reports.unshift(report);
  saveReports();
  renderCases();
  els.sosState.innerHTML = `<strong>Emergency created</strong><span>Contacts and response services are now visible in the workflow.</span>`;
  showToast("Critical SOS case created.");
}

function exportReports() {
  const blob = new Blob([JSON.stringify(state.reports, null, 2)], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = `dcg-reports-${new Date().toISOString().slice(0, 10)}.json`;
  link.click();
  URL.revokeObjectURL(url);
}

function copyValue(value) {
  if (!value) return showToast("No contact available.");
  navigator.clipboard?.writeText(value).then(() => showToast("Copied.")).catch(() => showToast(value));
}

function relativeTime(value) {
  const date = new Date(value || Date.now());
  const minutes = Math.max(1, Math.round((Date.now() - date.getTime()) / 60000));
  if (minutes < 60) return `${minutes}m ago`;
  const hours = Math.round(minutes / 60);
  if (hours < 24) return `${hours}h ago`;
  return `${Math.round(hours / 24)}d ago`;
}

function escapeHtml(value) {
  return String(value).replace(/[&<>"']/g, (char) => {
    return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#039;" }[char];
  });
}

function showToast(message) {
  els.toast.textContent = message;
  els.toast.classList.add("show");
  window.clearTimeout(showToast.timer);
  showToast.timer = window.setTimeout(() => els.toast.classList.remove("show"), 2600);
}

function tickClock() {
  els.clock.textContent = new Intl.DateTimeFormat("en", { hour: "numeric", minute: "2-digit" }).format(new Date());
}

function bindEvents() {
  els.form.addEventListener("submit", submitReport);
  els.exportButton.addEventListener("click", exportReports);
  els.openSosButton.addEventListener("click", openSosModal);
  els.closeSosButton.addEventListener("click", closeSosModal);

  els.holdSosButton.addEventListener("pointerdown", beginSosHold);
  els.holdSosButton.addEventListener("pointerup", cancelSosHold);
  els.holdSosButton.addEventListener("pointerleave", cancelSosHold);
  els.holdSosButton.addEventListener("keydown", (event) => {
    if (event.key === " " || event.key === "Enter") beginSosHold();
  });
  els.holdSosButton.addEventListener("keyup", cancelSosHold);

  els.searchInput.addEventListener("input", (event) => {
    state.filters.search = event.target.value;
    renderCases();
  });
  els.statusFilter.addEventListener("change", (event) => {
    state.filters.status = event.target.value;
    renderCases();
  });
  els.priorityFilter.addEventListener("change", (event) => {
    state.filters.priority = event.target.value;
    renderCases();
  });

  els.signInButton.addEventListener("click", () => {
    state.user = state.user ? null : { name: "Campus Responder", id: "local" };
    saveUser();
    updateUserUi();
    showToast(state.user ? "Responder signed in." : "Signed out.");
  });

  document.addEventListener("click", (event) => {
    const category = event.target.closest("[data-category]");
    if (category) {
      state.selectedCategory = category.dataset.category;
      renderCategories();
    }

    const status = event.target.closest("[data-status-id]");
    if (status) updateStatus(status.dataset.statusId, status.dataset.nextStatus);

    const copy = event.target.closest("[data-copy]");
    if (copy) copyValue(copy.dataset.copy);

    const sosLocation = event.target.closest("[data-sos-location]");
    if (sosLocation) {
      createSosCase(sosLocation.dataset.sosLocation);
      closeSosModal();
    }
  });

  els.sosModal.addEventListener("click", (event) => {
    if (event.target === els.sosModal) closeSosModal();
  });
}

renderCategories();
renderContacts();
renderCases();
updateUserUi();
bindEvents();
initFirebase();
tickClock();
window.setInterval(tickClock, 30000);
