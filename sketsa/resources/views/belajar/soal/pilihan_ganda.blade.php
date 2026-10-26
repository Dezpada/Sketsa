<div class="opsi-list">
  @foreach ($tantangan->item as $i => $item)
    <button type="button" class="opsi" data-item-id="{{ $item->id }}" aria-pressed="false">
      <b>{{ chr(97 + $i) }}</b>
      <span>{{ $item->konten }}</span>
    </button>
  @endforeach
</div>
