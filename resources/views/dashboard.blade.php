<x-app-layout>
@php
    $priceP1 = App\Models\Setting::getVal('price_gm_epic', 60000);
    $priceP2 = App\Models\Setting::getVal('price_epic_legend', 100000);
    $priceP3 = App\Models\Setting::getVal('price_legend_mythic', 150000);

    $starGm = App\Models\Setting::getVal('star_grandmaster', 3000);
    $starEpic = App\Models\Setting::getVal('star_epic', 4000);
    $starLegend = App\Models\Setting::getVal('star_legend', 6000);
    $starMythic = App\Models\Setting::getVal('star_mythic', 9000);
    $starHonor = App\Models\Setting::getVal('star_honor', 13000);
    $starGlory = App\Models\Setting::getVal('star_glory', 30000);
    $starImmortal = App\Models\Setting::getVal('star_immortal', 100000);
@endphp
    <x-slot name="header">
        <h2 class="font-bold text-2xl text-neon leading-tight">
            Dashboard
        </h2>
    </x-slot>

    <div class="py-8">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-8">

            {{-- Welcome Card --}}
            <div class="glass-card p-8 relative overflow-hidden">
                <div class="bg-orb bg-orb-blue w-48 h-48 -top-24 -right-24"></div>
                <div class="flex flex-col lg:flex-row items-center justify-between gap-8">
                    <div class="flex-1">
                        <h1 class="text-3xl font-black text-white mb-2">
                            Selamat Datang @if(Auth::user()->role === 'admin') Admin @endif <span class="text-neon">{{ Auth::user()->name }}!</span> 👋
                        </h1>
                        <p class="text-gray-400 mb-6">Upgrade rank akun Mobile Legends kamu sekarang juga bersama joki profesional kami.</p>
                        <div class="flex flex-wrap gap-3">
                            <span class="badge-feature">✔️ Aman 100%</span>
                            <span class="badge-feature">⚡ Proses Cepat</span>
                            <span class="badge-feature">💰 Harga Terjangkau</span>
                        </div>
                    </div>
                    <div class="shrink-0">
                        <img src="{{ asset('img/rank.png') }}" alt="Rank" class="w-48 lg:w-56 animate-float drop-shadow-2xl">
                    </div>
                </div>
            </div>

            {{-- Menampilkan Order History atau Admin Orders --}}
            <div>
                <div class="divider-neon"></div>
                <h2 class="section-title text-white">
                    @if(Auth::user()->role === 'admin')
                        Daftar Order <span class="text-neon">Masuk</span>
                        @php $pendingCount = $orders->where('status', 'pending')->count(); @endphp
                        @if($pendingCount > 0)
                            <span class="ml-2 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-red-100 bg-red-600 rounded-full">{{ $pendingCount }} Baru</span>
                        @endif
                    @else
                        Riwayat <span class="text-neon">Order Saya</span>
                    @endif
                </h2>
                
                <div class="glass-card p-6 overflow-x-auto">
                    @if(session('success'))
                        <div class="mb-4 p-4 rounded-xl bg-green-500/20 border border-green-500/50 text-green-400">
                            {{ session('success') }}
                        </div>
                    @endif

                    @if($orders->isEmpty())
                        <p class="text-gray-400 text-center py-4">Belum ada order.</p>
                    @else
                        <table class="w-full text-sm text-left">
                            <thead>
                                <tr class="border-b border-white/10 text-gaming-400">
                                    <th class="py-3 px-4">ID</th>
                                    @if(Auth::user()->role === 'admin')
                                    <th class="py-3 px-4">User</th>
                                    @endif
                                    <th class="py-3 px-4">Detail</th>
                                    <th class="py-3 px-4">Harga</th>
                                    <th class="py-3 px-4">Status Bayar</th>
                                    <th class="py-3 px-4">Status Order</th>
                                    <th class="py-3 px-4">Aksi</th>
                                </tr>
                            </thead>
                            <tbody class="text-gray-300">
                                @foreach($orders as $o)
                                <tr class="border-b border-white/5 hover:bg-white/5 transition-colors">
                                    <td class="py-3 px-4">#{{ $o->id }}</td>
                                    @if(Auth::user()->role === 'admin')
                                    <td class="py-3 px-4">{{ $o->user->name ?? 'User' }}</td>
                                    @endif
                                    <td class="py-3 px-4">
                                        @if($o->type === 'paket')
                                            Paket: {{ $o->paket_name }}
                                        @else
                                            Custom: {{ $o->from_rank }} ({{ $o->from_star }}⭐) → {{ $o->to_rank }} ({{ $o->to_star }}⭐)
                                        @endif
                                        
                                        @if(Auth::user()->role === 'admin')
                                        <div class="mt-2 text-xs text-gray-400 p-2 bg-dark-900 rounded-lg">
                                            <div><span class="text-gray-500">Nama:</span> {{ $o->customer_name }}</div>
                                            <div><span class="text-gray-500">Game ID:</span> {{ $o->game_id }}</div>
                                            <div><span class="text-gray-500">Akun:</span> {{ $o->moonton_account }}</div>
                                            <div><span class="text-gray-500">Pass:</span> {{ $o->moonton_password }}</div>
                                            <div><span class="text-gray-500">Hero:</span> {{ $o->hero_request ?? '-' }}</div>
                                            <div><span class="text-gray-500">WA:</span> {{ $o->whatsapp }}</div>
                                        </div>
                                        @endif
                                    </td>
                                    <td class="py-3 px-4 text-neon">Rp {{ number_format($o->price, 0, ',', '.') }}</td>
                                    <td class="py-3 px-4">
                                        @if($o->payment_status === 'unpaid')
                                            <span class="px-2 py-1 bg-red-500/20 text-red-400 rounded-md text-xs">Unpaid</span>
                                        @elseif($o->payment_status === 'verified' || $o->payment_status === 'sudah dibayar')
                                            <span class="px-2 py-1 bg-green-500/20 text-green-400 rounded-md text-xs">{{ ucfirst($o->payment_status) }}</span>
                                        @else
                                            <span class="px-2 py-1 bg-yellow-500/20 text-yellow-400 rounded-md text-xs">{{ $o->payment_status }}</span>
                                        @endif
                                    </td>
                                    <td class="py-3 px-4">
                                        <span class="px-2 py-1 bg-gaming-500/20 text-gaming-300 rounded-md text-xs">{{ ucfirst($o->status) }}</span>
                                    </td>
                                    <td class="py-3 px-4">
                                        @if($o->payment_status === 'unpaid' && Auth::id() === $o->user_id)
                                            <a href="{{ route('order.payment', $o->id) }}" class="text-xs bg-neon-purple text-white px-3 py-1 rounded-md hover:bg-purple-600 transition inline-block mb-1">Bayar</a>
                                        @endif
                                        @if(Auth::user()->role === 'admin')
                                            <form action="{{ route('order.status', $o->id) }}" method="POST" class="inline-block mt-1">
                                                @csrf
                                                @method('PATCH')
                                                <select name="status" onchange="this.form.submit()" class="text-xs bg-dark-800 border-white/10 text-white rounded-md p-1">
                                                    <option value="pending" {{ $o->status === 'pending' ? 'selected' : '' }}>Pending</option>
                                                    <option value="on progress" {{ $o->status === 'on progress' ? 'selected' : '' }}>On Progress</option>
                                                    <option value="selesai" {{ $o->status === 'selesai' ? 'selected' : '' }}>Selesai</option>
                                                </select>
                                            </form>
                                        @elseif($o->status === 'processing' || $o->status === 'on progress')
                                            <span class="text-xs text-gray-500">Proses...</span>
                                        @endif
                                    </td>
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    @endif
                </div>
            </div>

            {{-- Admin Settings Form --}}
            @if(Auth::user()->role === 'admin')
            <div>
                <div class="divider-neon"></div>
                <h2 class="section-title text-white">Pengaturan <span class="text-neon">Harga</span></h2>
                <div class="glass-card p-8">
                    <form action="{{ route('admin.settings') }}" method="POST">
                        @csrf
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                            <!-- Harga Paket -->
                            <div>
                                <h3 class="text-lg font-bold text-gaming-300 mb-4 border-b border-white/10 pb-2">Harga Paket</h3>
                                <div class="space-y-4">
                                    <div>
                                        <label class="block text-sm text-gray-400 mb-1">Grandmaster → Epic</label>
                                        <input type="number" name="price_gm_epic" value="{{ $priceP1 }}" class="w-full bg-dark-800 border-white/10 rounded-lg text-white">
                                    </div>
                                    <div>
                                        <label class="block text-sm text-gray-400 mb-1">Epic → Legend</label>
                                        <input type="number" name="price_epic_legend" value="{{ $priceP2 }}" class="w-full bg-dark-800 border-white/10 rounded-lg text-white">
                                    </div>
                                    <div>
                                        <label class="block text-sm text-gray-400 mb-1">Legend → Mythic</label>
                                        <input type="number" name="price_legend_mythic" value="{{ $priceP3 }}" class="w-full bg-dark-800 border-white/10 rounded-lg text-white">
                                    </div>
                                </div>
                            </div>
                            <!-- Harga Per Bintang -->
                            <div>
                                <h3 class="text-lg font-bold text-gaming-300 mb-4 border-b border-white/10 pb-2">Harga Per Bintang</h3>
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <label class="block text-sm text-gray-400 mb-1">Grandmaster</label>
                                        <input type="number" name="star_grandmaster" value="{{ $starGm }}" class="w-full bg-dark-800 border-white/10 rounded-lg text-white">
                                    </div>
                                    <div>
                                        <label class="block text-sm text-gray-400 mb-1">Epic</label>
                                        <input type="number" name="star_epic" value="{{ $starEpic }}" class="w-full bg-dark-800 border-white/10 rounded-lg text-white">
                                    </div>
                                    <div>
                                        <label class="block text-sm text-gray-400 mb-1">Legend</label>
                                        <input type="number" name="star_legend" value="{{ $starLegend }}" class="w-full bg-dark-800 border-white/10 rounded-lg text-white">
                                    </div>
                                    <div>
                                        <label class="block text-sm text-gray-400 mb-1">Mythic</label>
                                        <input type="number" name="star_mythic" value="{{ $starMythic }}" class="w-full bg-dark-800 border-white/10 rounded-lg text-white">
                                    </div>
                                    <div>
                                        <label class="block text-sm text-gray-400 mb-1">Honor</label>
                                        <input type="number" name="star_honor" value="{{ $starHonor }}" class="w-full bg-dark-800 border-white/10 rounded-lg text-white">
                                    </div>
                                    <div>
                                        <label class="block text-sm text-gray-400 mb-1">Glory</label>
                                        <input type="number" name="star_glory" value="{{ $starGlory }}" class="w-full bg-dark-800 border-white/10 rounded-lg text-white">
                                    </div>
                                    <div class="col-span-2">
                                        <label class="block text-sm text-gray-400 mb-1">Immortal</label>
                                        <input type="number" name="star_immortal" value="{{ $starImmortal }}" class="w-full bg-dark-800 border-white/10 rounded-lg text-white">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="mt-6 text-right">
                            <button type="submit" class="btn-neon text-sm px-6 py-2">Simpan Perubahan</button>
                        </div>
                    </form>
                </div>
            </div>
            @endif

            {{-- Paket Joki Grid --}}
            @if(Auth::user()->role !== 'admin')
            <div>
                <div class="divider-neon"></div>
                <h2 class="section-title text-white">Paket <span class="text-neon">Joki Rank</span></h2>
                <p class="section-subtitle">Pilih paket yang sesuai dengan kebutuhan rank kamu</p>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    @php
                    $pakets = [
                        ['from'=>'Grandmaster','to'=>'Epic','price'=>'Rp '.number_format($priceP1, 0, ',', '.'),'raw_price'=>$priceP1,'color'=>'from-purple-500 to-pink-400','icon'=>'💎'],
                        ['from'=>'Epic','to'=>'Legend','price'=>'Rp '.number_format($priceP2, 0, ',', '.'),'raw_price'=>$priceP2,'color'=>'from-orange-500 to-red-400','icon'=>'🔥'],
                        ['from'=>'Legend','to'=>'Mythic','price'=>'Rp '.number_format($priceP3, 0, ',', '.'),'raw_price'=>$priceP3,'color'=>'from-red-500 to-pink-500','icon'=>'👑','popular'=>true],
                    ];
                    @endphp

                    @foreach($pakets as $p)
                    <div class="package-card group">
                        @if(!empty($p['popular']))
                            <div class="package-badge">🔥 Terpopuler</div>
                        @endif
                        <div class="flex items-center gap-3 mb-4 {{ !empty($p['popular']) ? 'mt-4' : 'mt-2' }}">
                            <div class="w-12 h-12 rounded-xl bg-gradient-to-br {{ $p['color'] }} flex items-center justify-center text-2xl shadow-lg">
                                {{ $p['icon'] }}
                            </div>
                            <div>
                                <h3 class="font-bold text-white text-lg">{{ $p['from'] }} → {{ $p['to'] }}</h3>
                            </div>
                        </div>
                        <div class="flex items-end gap-1 mb-5">
                            <span class="text-2xl font-black text-neon-blue">{{ $p['price'] }}</span>
                        </div>
                        <ul class="space-y-2 mb-6 text-sm text-gray-400">
                            <li class="flex items-center gap-2"><span class="text-green-400">✓</span> Proses 1-3 hari</li>
                            <li class="flex items-center gap-2"><span class="text-green-400">✓</span> Garansi keamanan</li>
                        </ul>
                        <form action="{{ route('order.init') }}" method="POST">
                            @csrf
                            <input type="hidden" name="type" value="paket">
                            <input type="hidden" name="paket_name" value="{{ $p['from'] }} → {{ $p['to'] }}">
                            <input type="hidden" name="price" value="{{ $p['raw_price'] }}">
                            <button type="submit" class="block w-full text-center btn-neon !rounded-xl text-sm border-0 cursor-pointer">
                                Pesan Sekarang
                            </button>
                        </form>
                    </div>
                    @endforeach
                </div>
            </div>
            @endif

            {{-- Kalkulator Joki Custom --}}
            <div x-data="kalkulatorJoki()">
                <div class="divider-neon"></div>
                <h2 class="section-title text-white">Kalkulator <span class="text-neon">Joki Custom</span></h2>
                <p class="section-subtitle">Hitung biaya joki sesuai rank dan bintang kamu</p>

                <div class="glass-card p-8">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div>
                            <label class="block text-sm font-semibold text-gaming-300 mb-2">📍 Rank Saat Ini</label>
                            <select x-model="fromRank" @change="calculate()" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500">
                                <option value="">-- Pilih Rank --</option>
                                <template x-for="r in ranks" :key="r.id"><option :value="r.id" x-text="r.name"></option></template>
                            </select>
                            <label class="block text-sm font-semibold text-gaming-300 mb-2">⭐ Bintang Saat Ini</label>
                            <template x-if="!isFreeInput(fromRank)">
                                <select x-model="fromStar" @change="calculate()" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500">
                                    <option value="">-- Pilih Bintang --</option>
                                    <template x-for="s in getStarOptions(fromRank)" :key="s"><option :value="s" x-text="s + ' ⭐'"></option></template>
                                </select>
                            </template>
                            <template x-if="isFreeInput(fromRank)">
                                <input type="number" x-model="fromStar" @input="calculate()" min="0" placeholder="Masukkan jumlah bintang" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500">
                            </template>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-gaming-300 mb-2">🎯 Rank Tujuan</label>
                            <select x-model="toRank" @change="calculate()" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500">
                                <option value="">-- Pilih Rank --</option>
                                <template x-for="r in getTargetRanks()" :key="r.id"><option :value="r.id" x-text="r.name"></option></template>
                            </select>
                            <label class="block text-sm font-semibold text-gaming-300 mb-2">⭐ Bintang Tujuan</label>
                            <template x-if="!isFreeInput(toRank)">
                                <select x-model="toStar" @change="calculate()" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500">
                                    <option value="">-- Pilih Bintang --</option>
                                    <template x-for="s in getStarOptions(toRank)" :key="s"><option :value="s" x-text="s + ' ⭐'"></option></template>
                                </select>
                            </template>
                            <template x-if="isFreeInput(toRank)">
                                <input type="number" x-model="toStar" @input="calculate()" min="0" placeholder="Masukkan jumlah bintang" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500">
                            </template>
                        </div>
                    </div>
                    <div x-show="totalCost > 0" x-transition class="mt-8 p-6 rounded-2xl bg-gradient-to-br from-gaming-500/10 to-neon-purple/10 border border-gaming-500/30 text-center">
                        <p class="text-gray-400 text-sm mb-2">Total Biaya Joki</p>
                        <p class="text-4xl font-black text-neon mb-2" x-text="'Rp ' + totalCost.toLocaleString('id-ID')"></p>
                        <p class="text-gray-400 text-sm mb-1" x-text="'Total ' + totalStars + ' bintang'"></p>
                        <p class="text-gray-500 text-xs mb-6" x-text="detail"></p>
                        <form action="{{ route('order.init') }}" method="POST" class="inline-block mt-2">
                            @csrf
                            <input type="hidden" name="type" value="custom">
                            <input type="hidden" name="from_rank" :value="getFromName()">
                            <input type="hidden" name="to_rank" :value="getToName()">
                            <input type="hidden" name="from_star" :value="fromStar">
                            <input type="hidden" name="to_star" :value="toStar">
                            <input type="hidden" name="price" :value="totalCost">
                            <button type="submit" class="btn-neon text-sm border-0 cursor-pointer">
                                💳 Pesan & Bayar
                            </button>
                        </form>
                    </div>
                    <div x-show="errorMsg" x-transition class="mt-6 p-4 rounded-xl bg-red-500/10 border border-red-500/30 text-red-400 text-sm text-center" x-text="errorMsg"></div>
                </div>

                <script>
                function kalkulatorJoki() {
                    return {
                        fromRank: '', fromStar: '', toRank: '', toStar: '',
                        totalCost: 0, totalStars: 0, detail: '', errorMsg: '',
                        ranks: [
                            { id: 'epic5', name: 'Epic V', tier: 'epic', order: 1, maxStar: 5 },
                            { id: 'epic4', name: 'Epic IV', tier: 'epic', order: 2, maxStar: 5 },
                            { id: 'epic3', name: 'Epic III', tier: 'epic', order: 3, maxStar: 5 },
                            { id: 'epic2', name: 'Epic II', tier: 'epic', order: 4, maxStar: 5 },
                            { id: 'epic1', name: 'Epic I', tier: 'epic', order: 5, maxStar: 5 },
                            { id: 'legend5', name: 'Legend V', tier: 'legend', order: 6, maxStar: 5 },
                            { id: 'legend4', name: 'Legend IV', tier: 'legend', order: 7, maxStar: 5 },
                            { id: 'legend3', name: 'Legend III', tier: 'legend', order: 8, maxStar: 5 },
                            { id: 'legend2', name: 'Legend II', tier: 'legend', order: 9, maxStar: 5 },
                            { id: 'legend1', name: 'Legend I', tier: 'legend', order: 10, maxStar: 5 },
                            { id: 'mythic', name: 'Mythic', tier: 'mythic', order: 11, maxStar: 5, freeInput: true },
                            { id: 'mythic_honor', name: 'Mythic Honor', tier: 'mythic_honor', order: 12, maxStar: 5, freeInput: true },
                            { id: 'mythical_glory', name: 'Mythical Glory', tier: 'mythical_glory', order: 13, maxStar: 5, freeInput: true },
                            { id: 'immortal', name: 'Immortal', tier: 'immortal', order: 14, maxStar: 5, freeInput: true },
                        ],
                        tierPrice: { epic: {{ $starEpic }}, legend: {{ $starLegend }}, mythic: {{ $starMythic }}, mythic_honor: {{ $starHonor }}, mythical_glory: {{ $starGlory }}, immortal: {{ $starImmortal }} },
                        isFreeInput(rankId) { let r = this.getRank(rankId); return r ? !!r.freeInput : false; },
                        getRank(id) { return this.ranks.find(r => r.id === id); },
                        getFromName() { let r = this.getRank(this.fromRank); return r ? r.name : ''; },
                        getToName() { let r = this.getRank(this.toRank); return r ? r.name : ''; },
                        getStarOptions(rankId) { let r = this.getRank(rankId); if (!r) return []; let o=[]; for (let i=0;i<=r.maxStar;i++) o.push(i); return o; },
                        getTargetRanks() {
                            if (!this.fromRank) return this.ranks;
                            let from = this.getRank(this.fromRank);
                            if (!from) return this.ranks;
                            return this.ranks.filter(r => r.order >= from.order);
                        },
                        calculate() {
                            this.totalCost = 0; this.totalStars = 0; this.detail = ''; this.errorMsg = '';
                            if (!this.fromRank || this.fromStar === '' || !this.toRank || this.toStar === '') return;

                            let from = this.getRank(this.fromRank);
                            let to = this.getRank(this.toRank);
                            if (!from || !to) return;

                            if (to.order < from.order) {
                                this.errorMsg = 'Rank tujuan harus lebih tinggi atau sama dengan rank saat ini!';
                                return;
                            }
                            if (to.order === from.order && parseInt(this.toStar) <= parseInt(this.fromStar)) {
                                this.errorMsg = 'Bintang tujuan harus lebih tinggi!';
                                return;
                            }

                            let cost = 0, stars = 0, details = [];
                            let fromIdx = this.ranks.findIndex(r => r.id === this.fromRank);
                            let toIdx = this.ranks.findIndex(r => r.id === this.toRank);
                            let fStar = parseInt(this.fromStar);
                            let tStar = parseInt(this.toStar);

                            if (fromIdx === toIdx) {
                                let diff = tStar - fStar;
                                let price = this.tierPrice[from.tier];
                                if (price && diff > 0) {
                                    cost = diff * price;
                                    stars = diff;
                                    details.push(from.name + ': ' + diff + '⭐ × Rp ' + price.toLocaleString('id-ID'));
                                }
                            } else {
                                for (let i = fromIdx; i < toIdx; i++) {
                                    let rank = this.ranks[i];
                                    let price = this.tierPrice[rank.tier];
                                    if (!price) continue;
                                    let s = (i === fromIdx) ? (rank.maxStar - fStar) : rank.maxStar;
                                    if (s > 0) {
                                        cost += s * price;
                                        stars += s;
                                        details.push(rank.name + ': ' + s + '⭐ × Rp ' + price.toLocaleString('id-ID'));
                                    }
                                }
                                
                                if (tStar > 0) {
                                    let toRankData = this.ranks[toIdx];
                                    let prevTier = toIdx > 0 ? this.ranks[toIdx - 1].tier : toRankData.tier;
                                    let price = this.tierPrice[prevTier] || this.tierPrice[toRankData.tier];
                                    if (price) {
                                        cost += tStar * price;
                                        stars += tStar;
                                        details.push(toRankData.name + ': ' + tStar + '⭐ × Rp ' + price.toLocaleString('id-ID'));
                                    }
                                }
                            }

                            this.totalCost = cost;
                            this.totalStars = stars;
                            this.detail = details.join(' | ');
                        }
                    }
                }
                </script>
            </div>

            {{-- Testimoni --}}
            <div>
                <div class="divider-neon"></div>
                <h2 class="section-title text-white">Testimoni <span class="text-neon">Pelanggan</span></h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <!-- @php
                    $tests = [
                        ['name'=>'Andi','from'=>'GM','to'=>'Epic','msg'=>'Cuma 2 hari udah Epic. Mantap!','av'=>'A'],
                        ['name'=>'Siti','from'=>'Epic','to'=>'Legend','msg'=>'Pelayanan ramah, akun aman.','av'=>'S'],
                        ['name'=>'Budi','from'=>'Legend','to'=>'Mythic','msg'=>'Worth it banget!','av'=>'B'],
                    ];
                    @endphp -->
                    @foreach($tests as $t)
                    <div class="gaming-card">
                        <div class="flex items-center gap-3 mb-3">
                            <div class="w-10 h-10 rounded-full bg-gradient-to-br from-gaming-500 to-neon-purple flex items-center justify-center text-white font-bold">{{ $t['av'] }}</div>
                            <div>
                                <h4 class="font-semibold text-white text-sm">{{ $t['name'] }}</h4>
                                <span class="text-xs text-gaming-300">{{ $t['from'] }} → {{ $t['to'] }}</span>
                            </div>
                        </div>
                        <p class="text-gray-400 text-sm italic">"{{ $t['msg'] }}"</p>
                        <div class="star-rating mt-2"><span>⭐⭐⭐⭐⭐</span></div>
                    </div>
                    @endforeach
                </div>
            </div>

            {{-- FAQ --}}
            <div x-data="{ openFaq: null }">
                <div class="divider-neon"></div>
                <h2 class="section-title text-white">FAQ</h2>
                <div class="max-w-3xl mx-auto space-y-3">
                    @php
                    $faqs = [
                        ['q'=>'Apakah akun aman?','a'=>'Ya, 100% aman! Kami menggunakan VPN dan teknik anti-detect.'],
                        ['q'=>'Berapa lama proses joki?','a'=>'Rata-rata 1-3 hari kerja tergantung paket.'],
                        ['q'=>'Bisa request hero?','a'=>'Tentu! Anda bisa request hero favorit.'],
                    ];
                    @endphp
                    @foreach($faqs as $i => $faq)
                    <div class="accordion-item">
                        <button @click="openFaq = openFaq === {{ $i }} ? null : {{ $i }}" class="accordion-header">
                            <span>{{ $faq['q'] }}</span>
                            <svg :class="{ 'rotate-180': openFaq === {{ $i }} }" class="w-5 h-5 transition-transform duration-300 text-gaming-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7"/>
                            </svg>
                        </button>
                        <div x-show="openFaq === {{ $i }}" x-transition:enter="transition ease-out duration-200" x-transition:enter-start="opacity-0 transform -translate-y-2" x-transition:enter-end="opacity-100 transform translate-y-0" x-transition:leave="transition ease-in duration-150" x-transition:leave-start="opacity-100" x-transition:leave-end="opacity-0" class="px-5 pb-5 text-gray-400 text-sm">
                            {{ $faq['a'] }}
                        </div>
                    </div>
                    @endforeach
                </div>
            </div>

            {{-- Testimoni Pelanggan --}}
            <div>
                <div class="divider-neon"></div>
                <h2 class="section-title text-white">Testimoni <span class="text-neon">Pelanggan</span></h2>
                
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                    @forelse($testimonials as $t)
                    <div class="glass-card p-6">
                        <div class="flex items-center gap-4 mb-4">
                            <div class="w-12 h-12 bg-gaming-500 rounded-full flex items-center justify-center font-bold text-white">
                                {{ strtoupper(substr($t->user->name, 0, 2)) }}
                            </div>
                            <div>
                                <h4 class="font-bold text-white">{{ $t->user->name }}</h4>
                                <div class="text-yellow-400 text-sm">
                                    @for($i=0; $i<$t->rating; $i++) ⭐ @endfor
                                </div>
                            </div>
                        </div>
                        <p class="text-gray-400 text-sm">"{{ $t->content }}"</p>
                        
                        @if($t->reply)
                            <div class="mt-4 p-3 bg-dark-800/80 rounded-xl border border-gaming-500/30">
                                <p class="text-xs font-bold text-neon-blue mb-1">Admin Reply:</p>
                                <p class="text-gray-300 text-xs">{{ $t->reply }}</p>
                            </div>
                        @endif

                        <div class="mt-4 flex flex-col gap-2">
                            @if(Auth::user()->role === 'admin' && !$t->reply)
                                <form action="{{ route('testimonial.reply', $t->id) }}" method="POST" class="w-full">
                                    @csrf
                                    <div class="flex gap-2">
                                        <input type="text" name="reply" placeholder="Balas testimoni..." class="w-full text-xs bg-dark-800 border-white/10 rounded-md text-white" required>
                                        <button type="submit" class="bg-neon-purple text-white px-3 py-1 rounded-md text-xs hover:bg-purple-600 transition">Balas</button>
                                    </div>
                                </form>
                            @endif

                            @if(Auth::user()->role === 'admin' || Auth::id() === $t->user_id)
                                <form action="{{ route('testimonial.destroy', $t->id) }}" method="POST" class="text-right mt-2">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="text-xs text-red-500 hover:text-red-400 transition" onclick="return confirm('Hapus testimoni ini?')">Hapus</button>
                                </form>
                            @endif
                        </div>
                    </div>
                    @empty
                    <div class="col-span-3 text-center text-gray-500 py-4">Belum ada testimoni. Jadilah yang pertama!</div>
                    @endforelse
                </div>

                <div class="glass-card p-6 md:w-1/2 mx-auto">
                    <h3 class="font-bold text-white mb-4">Tambahkan Testimoni Anda</h3>
                    <form action="{{ route('testimonial.store') }}" method="POST">
                        @csrf
                        <div class="mb-4">
                            <label class="block text-sm text-gray-400 mb-1">Rating</label>
                            <select name="rating" class="w-full bg-dark-800 border-white/10 rounded-lg text-white">
                                <option value="5">⭐⭐⭐⭐⭐ Sangat Bagus</option>
                                <option value="4">⭐⭐⭐⭐ Bagus</option>
                                <option value="3">⭐⭐⭐ Lumayan</option>
                                <option value="2">⭐⭐ Kurang</option>
                                <option value="1">⭐ Buruk</option>
                            </select>
                        </div>
                        <div class="mb-4">
                            <label class="block text-sm text-gray-400 mb-1">Ulasan</label>
                            <textarea name="content" rows="3" class="w-full bg-dark-800 border-white/10 rounded-lg text-white" placeholder="Bagaimana pengalaman Anda menggunakan jasa kami?"></textarea>
                        </div>
                        <button type="submit" class="btn-neon w-full text-sm py-2">Kirim Testimoni</button>
                    </form>
                </div>
            </div>

        </div>
    </div>
</x-app-layout>